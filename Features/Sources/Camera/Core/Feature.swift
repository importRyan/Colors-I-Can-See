// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture
import Models

public struct Camera: ReducerProtocol {

  public struct State: Equatable {
    @BindableState
    var vision: VisionType = .deutan
  }

  public enum Action: BindableAction {
    case pressedCapturePhoto
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .pressedCapturePhoto:
        return .none
      case .binding:
        return .none
      }
    }
  }
}
