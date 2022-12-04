// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture
import Models

public struct Onboarding: ReducerProtocol {

  public init() {
    
  }

  public struct State: Equatable, Hashable, Identifiable {
    public init(vision: VisionType = .deutan) {
      self.vision = vision
    }


    @BindableState
    var vision: VisionType = .deutan
    public var id: Self { self }
  }

  public enum Action: BindableAction, Equatable {
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
