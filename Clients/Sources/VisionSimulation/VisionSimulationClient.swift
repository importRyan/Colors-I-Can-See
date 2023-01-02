// Copyright 2022 by Ryan Ferrell. @importRyan

import AsyncAlgorithms
import TCA
import VisionType

import class CoreImage.CIImage
import class CoreGraphics.CGImage

public struct VisionSimulationClient {
  public var initialize: @Sendable (_ initialSimulation: VisionType) async throws -> InitializationSuccess
  public var cameraAuthorize: @Sendable () async -> Result<AuthorizationSuccess, AuthorizationError>
  public var cameraAuthorizationStatus: () -> Result<AuthorizationSuccess, AuthorizationError>
  public var cameraStart: @Sendable () async -> Result<CameraSuccess, CameraError>
  public var cameraRestart: @Sendable () async -> ()
  public var cameraStop: @Sendable () async -> ()
  public var cameraChangeSimulation: @Sendable (_ newSimulation: VisionType) async -> Void
  public var errors: @Sendable () -> AsyncChannel<Error>
  public var computeSimulations: @Sendable (CGImage) async throws -> [VisionType: CIImage]
}

// MARK: - Return Types

public struct InitializationSuccess: Equatable, Sendable {}

public enum InitializationError: Equatable, Error {
  case gpuUnavailable
  case gpuCommandsUnavailable
}

public struct AuthorizationSuccess: Equatable, Sendable {}

public enum AuthorizationError: Equatable, Error {
  case denied
  case notDetermined
  case restricted
  case unknown
}

public struct CameraSuccess: Equatable, Sendable {}

public enum CameraError: Equatable, Error {
  case noDevicesFound
  case cannotUseCameraInput
  case cannotSetupCameraDataOutput
  case unknown
}

public enum MetalError: Equatable, Error {
  case textureCacheCreationFailed
  case imageBufferNotAvailable
  case imageBufferTextureUnavailable
  case computeBufferNotAvailable
  case computeTextureCreationFailed
}

// MARK: - TCA

extension VisionSimulationClient: DependencyKey {
  public static let liveValue = VisionSimulationClient.live
  #if DEBUG
  public static let previewValue = VisionSimulationClient.mockSuccess
  public static let testValue = VisionSimulationClient.failing
  #endif
}

extension DependencyValues {
  public var visionSimulation: VisionSimulationClient {
    get { self[VisionSimulationClient.self] }
    set { self[VisionSimulationClient.self] = newValue }
  }
}
