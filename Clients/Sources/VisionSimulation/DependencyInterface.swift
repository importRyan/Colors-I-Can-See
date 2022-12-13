// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import ComposableArchitecture
import Foundation

public struct VisionSimulationClient {
  public var initialize: @Sendable (_ initialSimulation: VisionType) async throws -> InitializationSuccess
  public var changeSimulation: @Sendable (_ newSimulation: VisionType) async -> Void
}

// MARK: - Return Types

public struct InitializationSuccess: Equatable, Sendable {}

public enum InitializationError: Equatable, Error {
  case gpuUnavailable
  case gpuCommandsUnavailable
}

// MARK: - Localization

extension InitializationError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .gpuUnavailable:
      return String(localized: "Could not connect to your GPU.", bundle: .module)
    case .gpuCommandsUnavailable:
      return String(localized: "Could not enqueue commands to your GPU.", bundle: .module)
    }
  }
}

// MARK: - TCA

extension VisionSimulationClient: DependencyKey {
  public static let liveValue = VisionSimulationClient.live
  public static let previewValue = VisionSimulationClient.mockSuccess
  public static let testValue = VisionSimulationClient.failing
}

extension DependencyValues {
  public var visionSimulation: VisionSimulationClient {
    get { self[VisionSimulationClient.self] }
    set { self[VisionSimulationClient.self] = newValue }
  }
}
