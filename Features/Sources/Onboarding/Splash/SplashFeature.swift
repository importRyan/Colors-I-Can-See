// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture

public struct Splash: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public init() {}
  }

  public enum Action: Equatable {
    case pressedNext
    case send(SendAction)

    public enum SendAction: Equatable {
      case next
    }
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .pressedNext:
        return Effect(value: .send(.next))
          .animation(.easeIn(duration: 5))
      case .send:
        return .none
      }
    }
  }
}