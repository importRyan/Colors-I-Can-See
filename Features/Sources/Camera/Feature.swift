// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import VisionSimulation
import VisionType

public struct Camera: ReducerProtocol {

  @Dependency(\.visionSimulation) var visionSimulation

  public init() {
  }

  public struct State: Equatable, Hashable {
    @BindableState
    public var vision: VisionType
    public var status: StreamingStatus

    public init(
      vision: VisionType,
      status: StreamingStatus = .needsSetup
    ) {
      self.vision = vision
      self.status = status
    }

    public enum StreamingStatus {
      case needsSetup
      case settingUp
      case permissionsNotGranted
      case streaming
      case paused
      case resuming
    }
  }

  public enum Action: BindableAction, Equatable {
    case onAppear
    case onDisappear
    case requestCameraPermissions
    case requestCameraPermissionsResult(Result<AuthorizationSuccess, AuthorizationError>)
    case startCamera
    case startCameraResult(Result<CameraSuccess, CameraError>)
    case resumeCamera
    case resumeCameraComplete
    case pauseCamera
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard case .success = visionSimulation.cameraAuthorizationStatus() else {
          return .send(.requestCameraPermissions)
        }
        switch state.status {
        case .needsSetup: return .send(.requestCameraPermissions)
        case .settingUp: return .none
        case .permissionsNotGranted: return .none
        case .streaming: return .none
        case .paused: return .send(.resumeCamera)
        case .resuming: return .none
        }

      case .onDisappear:
        return .send(.pauseCamera)

      case .requestCameraPermissions:
        state.status = .settingUp
        return .run { send in
          let userPreference = await visionSimulation.cameraAuthorize()
          await send(.requestCameraPermissionsResult(userPreference))
        }

      case .requestCameraPermissionsResult(.success):
        return .send(.startCamera)

      case let .requestCameraPermissionsResult(.failure(error)):
        state.status = .permissionsNotGranted
        print(error)
        return .none

      case .startCamera:
        if state.status == .streaming { return .none }
        return .run { send in
          let result = await visionSimulation.cameraStart()
          await send(.startCameraResult(result))
        }

      case .startCameraResult(.success):
        state.status = .streaming
        return .none

      case let .startCameraResult(.failure(error)):
        print(error)
        state.status = .needsSetup
        return .none

      case .resumeCamera:
        state.status = .resuming
        return .run { send in
          await visionSimulation.cameraRestart()
          await send(.resumeCameraComplete)
        }

      case .resumeCameraComplete:
        state.status = .streaming
        return .none

      case .pauseCamera:
        state.status = .paused
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
