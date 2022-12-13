// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import Combine
import CoreImage
import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay

public struct MetalVisionSimulationClient {
  public var initialize: (_ initialVisionSimulation: VisionType) -> EffectTask<TaskResult<InitializationSuccess>>
  public var changeSimulation: (_ newSimulation: VisionType) -> Void

  public init(
    initialize: @escaping (_: VisionType) -> EffectTask<TaskResult<InitializationSuccess>>,
    changeSimulation: @escaping (_: VisionType) -> Void
  ) {
    self.initialize = initialize
    self.changeSimulation = changeSimulation
  }
}

// MARK: - Live

extension MetalVisionSimulationClient {
  static let live = Self.init(
    initialize: { initialVisionSimulation in
        .run { task in
          setupModuleInternalSingleton(with: initialVisionSimulation, send: task)
        }
    },
    changeSimulation: { newSimulation in
      guard let live = LiveClientCombine.live else {
        preconditionFailure("Must first initialize Metal and CIFilters.")
      }
      live.vision.send(newSimulation)
    }
  )
}

// MARK: - Internal

private func setupModuleInternalSingleton(
  with vision: VisionType,
  send: Send<TaskResult<InitializationSuccess>>
) {
  let queue = DispatchQueue(label: "com.ryanferrell.visionSimulation", qos: .userInteractive)
  queue.async {

    guard let device = MTLCreateSystemDefaultDevice() else {
      DispatchQueue.main.async {
        send(.failure(InitializationError.gpuUnavailable))
      }
      return
    }

    guard let commandQueue = device.makeCommandQueue() else {
      DispatchQueue.main.async {
        send(.failure(InitializationError.gpuCommandsUnavailable))
      }
      return
    }

    MachadoFilterVendor.registerFilters()

    LiveClientCombine.live = .init(
      device: device,
      initialSimulation: vision,
      queue: queue,
      realTimeCommandQueue: commandQueue
    )

    DispatchQueue.main.async {
      send(.success(.init()))
    }
  }
}

class LiveClientCombine {

  /// Initialize and use only from its private DispatchQueue
  fileprivate(set) static var live: LiveClientCombine?

  let queue: DispatchQueue
  var filter: CIFilter?
  private var filterUpdates: AnyCancellable?
  let vision: CurrentValueSubject<VisionType, Never>
  let device: MTLDevice
  let realtimeCommandQueue: MTLCommandQueue

  fileprivate init(
    device: MTLDevice,
    initialSimulation: VisionType,
    queue: DispatchQueue,
    realTimeCommandQueue: MTLCommandQueue
  ) {
    self.device = device
    self.queue = queue
    self.realtimeCommandQueue = realTimeCommandQueue
    self.vision = .init(initialSimulation)
    self.filterUpdates = self.vision
      .receive(on: self.queue)
      .debounce(for: .milliseconds(200), scheduler: self.queue)
      .sink { [weak self] newSimulation in
        guard let self else { return }
        self.filter = .init(vision: newSimulation)
      }
  }
}
