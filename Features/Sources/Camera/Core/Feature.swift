// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import ComposableArchitecture
import VisionSimulation

public struct Camera: ReducerProtocol {

  @Dependency(\.visionSimulation) var visionSimulation

  public init() {
    
  }

  public struct State: Equatable, Hashable {
    public init(vision: VisionType) {
      self.vision = vision
    }

    @BindableState
    public var vision: VisionType
  }

  public enum Action: BindableAction, Equatable {
    case pressedCapturePhoto
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .pressedCapturePhoto:
        return .none
      case .binding(\.$vision):
        return .run { [vision = state.vision] _ in
          await visionSimulation.changeSimulation(vision)
        }
      case .binding:
        return .none
      }
    }
  }
}
