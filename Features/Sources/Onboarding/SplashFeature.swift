// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA

public struct Splash: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public var didAppear = false
    public init() {}
  }

  public enum Action: Equatable {
    case onAppear
    case pressedLearn
    case pressedCamera
    case forParent(AscendingAction)

    public enum AscendingAction: Equatable {
      case pressedLearn
      case pressedCamera
    }
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.didAppear = true
        return .none
      case .pressedLearn:
        return .send(.forParent(.pressedLearn))
      case .pressedCamera:
        return .send(.forParent(.pressedCamera))
      case .forParent:
        return .none
      }
    }
  }
}
