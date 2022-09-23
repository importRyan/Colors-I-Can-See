// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture
import Models

public struct Onboarding: ReducerProtocol {

  public struct State: Equatable {
    @BindableState
    var vision: VisionType = .deutan
  }

  public enum Action: BindableAction {
    case pressedStartCamera
    case advanceToCamera(VisionType)
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .pressedStartCamera:
        return Effect(value: .advanceToCamera(state.vision))
      case .advanceToCamera:
        return .none
      case .binding:
        return .none
      }
    }
  }
}