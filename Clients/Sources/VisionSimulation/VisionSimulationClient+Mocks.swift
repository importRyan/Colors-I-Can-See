// Copyright 2022 by Ryan Ferrell. @importRyan

#if DEBUG
import AsyncAlgorithms
import XCTestDynamicOverlay
import VisionType

extension VisionSimulationClient {
  public static let failing = VisionSimulationClient.init(
    initialize: unimplemented("\(Self.self).initialize"),
    cameraAuthorize: unimplemented("\(Self.self).authorizeCamera"),
    cameraAuthorizationStatus: unimplemented("\(Self.self).authorizationCameraStatus"),
    cameraStart: unimplemented("\(Self.self).cameraStart"),
    cameraRestart: unimplemented("\(Self.self).cameraRestart"),
    cameraStop: unimplemented("\(Self.self).cameraStop"),
    cameraChangeSimulation: unimplemented("\(Self.self).changeSimulation"),
    errors: unimplemented("\(Self.self).errors"),
    computeSimulations: unimplemented("\(Self.self).computeSimulations")
  )


  public static let mockFailure = Self.init(
    initialize: { _ in
      throw InitializationError.gpuUnavailable
    },
    cameraAuthorize: {
      .failure(.denied)
    },
    cameraAuthorizationStatus: {
      .failure(.denied)
    },
    cameraStart: {
      .failure(CameraError.unknown)
    },
    cameraRestart: {

    },
    cameraStop: {

    },
    cameraChangeSimulation: { _ in
    },
    errors: {
      let errors = AsyncChannel<Error>()
      defer { errors.finish() }
      return errors
    },
    computeSimulations: { _ in
      throw MetalError.computeTextureCreationFailed
    }
  )

  public static let mockSuccess = {
    return Self.init(
      initialize: { _ in
          .init()
      },
      cameraAuthorize: {
        .success(.init())
      },
      cameraAuthorizationStatus: {
        .success(.init())
      },
      cameraStart: {
        .success(.init())
      },
      cameraRestart: {

      },
      cameraStop: {

      },
      cameraChangeSimulation: { _ in
      },
      errors: {
        .init()
      },
      computeSimulations: { _ in
          .init()
      }
    )
  }()
}
#endif
