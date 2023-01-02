// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import VisionSimulation
import VisionType

public struct Camera: ReducerProtocol {

  @Dependency(\.visionSimulation) var visionSimulation

  public init() {
  }

  public struct State: Equatable, Hashable {
    public init(vision: VisionType, didStart: Bool = false) {
      self.vision = vision
      self.didStart = didStart
    }

    @BindableState
    public var vision: VisionType
    public var didStart: Bool
  }

  public enum Action: BindableAction, Equatable {
    case onAppear
    case onDisappear
    case requestCameraPermissions
    case requestCameraPermissionsResult(Result<AuthorizationSuccess, AuthorizationError>)
    case startCamera
    case startCameraResult(Result<CameraSuccess, CameraError>)
    case resumeCamera
    case pauseCamera
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        if case .success = visionSimulation.cameraAuthorizationStatus(),
           state.didStart {
          return .send(.resumeCamera)
        } else {
          return .send(.requestCameraPermissions)
        }

      case .onDisappear:
        return .send(.pauseCamera)

      case .requestCameraPermissions:
        return .run { send in
          let userPreference = await visionSimulation.cameraAuthorize()
          await send(.requestCameraPermissionsResult(userPreference))
        }

      case .requestCameraPermissionsResult(.success):
        return .send(.startCamera)

      case let .requestCameraPermissionsResult(.failure(error)):
        print(error)
        return .none

      case .startCamera:
        if state.didStart { return .none }
        state.didStart = true
        return .run { send in
          let result = await visionSimulation.cameraStart()
          await send(.startCameraResult(result))
        }

      case .startCameraResult(.success):
        return .none

      case let .startCameraResult(.failure(error)):
        print(error)
        return .none

      case .resumeCamera:
        return .run { _ in
          await visionSimulation.cameraRestart()
        }

      case .pauseCamera:
        return .run { _ in
          await visionSimulation.cameraStop()
        }

      case .binding(\.$vision):
        return .run { [vision = state.vision] _ in
          await visionSimulation.cameraChangeSimulation(vision)
        }
      case .binding:
        return .none
      }
    }
  }
}
