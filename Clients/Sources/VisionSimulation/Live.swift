// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import Combine
import ComposableArchitecture
import MetalKit

extension VisionSimulationClient {
  public static let live = Self.init(
    initialize: { initialSimulation in
      try await setupMetalOnSpecificQueue(with: initialSimulation)
    },
    changeSimulation: { newSimulation in
      MetalController.live?.vision.send(newSimulation)
    }
  )
}

// MARK: - Module Internal Singleton

class MetalController {

  /// Initialize and use only from its private DispatchQueue
  fileprivate(set) static var live: MetalController?

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

// MARK: - Initialize Module Singleton

private func setupMetalOnSpecificQueue(with initialSimulation: VisionType) async throws -> InitializationSuccess {
  try await withCheckedThrowingContinuation { continuation in
    let queue = DispatchQueue(
      label: "com.ryanferrell.visionSimulation",
      qos: .userInteractive
    )
    queue.async {
      do {
        let success = try setupSingleton(queue, initialSimulation)
        continuation.resume(with: .success(success))
      } catch {
        continuation.resume(with: .failure(error))
      }
    }
  }
}

private func setupSingleton(
  _ queue: DispatchQueue,
  _ initialSimulation: VisionType
) throws -> InitializationSuccess {

  guard let device = MTLCreateSystemDefaultDevice() else {
    throw InitializationError.gpuUnavailable
  }
  guard let commandQueue = device.makeCommandQueue() else {
    throw InitializationError.gpuCommandsUnavailable
  }

  MachadoFilterVendor.registerFilters()

  MetalController.live = .init(
    device: device,
    initialSimulation: initialSimulation,
    queue: queue,
    realTimeCommandQueue: commandQueue
  )

  return .init()
}
