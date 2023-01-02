// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import VisionType

public struct LearnAboutVisionTypes: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public init(vision: VisionType = .deutan) {
      self.vision = vision
    }
    @BindableState
    var vision: VisionType = .deutan
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      }
    }
  }
}
