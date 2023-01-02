// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import Tabs
import VisionType

public struct Root: ReducerProtocol {

  public init() {}

  public enum State: Equatable, Hashable {
    case initialization
    case tabs(Tabs.State)
  }

  public enum Action: Equatable {
    case initialization(Initialization.Action)
    case tabs(Tabs.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    screens
    coordinator
  }

  @ReducerBuilder<State, Action>
  private var coordinator: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {

      case .initialization(.complete):
        state = .tabs(
          .init(
            initialTab: .learn,
            cameraTab: .init(vision: .deutan),
            learnTab: .initialState()
          )
        )
        return .none

      case .tabs, .initialization:
        return .none
      }
    }
  }

  // MARK: - Glue

  @ReducerBuilder<State, Action>
  private var screens: some ReducerProtocol<State, Action> {
    Scope(
      state: /State.tabs,
      action: /Action.tabs,
      Tabs.init
    )
    Scope(
      state: /State.initialization,
      action: /Action.initialization,
      Initialization.init
    )
  }

  public struct Screen: View {

    public init(store: StoreOf<Root>) {
      self.store = store
    }

    private let store: StoreOf<Root>

    public var body: some View {
      SwitchStore(store) {
        CaseLet(
          state: /State.tabs,
          action: Action.tabs,
          then: Tabs.Screen.init
        )
        CaseLet(
          state: /State.initialization,
          action: Action.initialization,
          then: Initialization.Screen.init
        )
      }
    }
  }
}
