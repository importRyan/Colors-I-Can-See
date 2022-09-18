// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import TCA

public struct VisionTypes: ReducerProtocol {

  public init() {
    
  }

  public struct State: Equatable, Hashable {
    public init(vision: VisionType = .deutan) {
      self.vision = vision
    }
    @BindableState
    var vision: VisionType = .deutan
  }

  public enum Action: BindableAction, Equatable {
    case pressedStartCamera
    case binding(BindingAction<State>)
    case send(SendAction)

    public enum SendAction: Equatable {
      case advanceToCamera(VisionType)
    }
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .pressedStartCamera:
        return Effect(value: .send(.advanceToCamera(state.vision)))
          .animation(.easeIn(duration: 5))
      case .binding:
        return .none
      case .send:
        return .none
      }
    }
  }
}
