// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA

public struct ImageGrid: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public var didAppear = false
    public init() {}
  }

  public enum Action: Equatable {
    case onAppear
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.didAppear = true
        return .none
      }
    }
  }
}
