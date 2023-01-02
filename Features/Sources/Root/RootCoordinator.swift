// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import Tabs
import Onboarding
import VisionType

public struct Root: ReducerProtocol {

  public init() {}

  public enum State: Equatable, Hashable {
    case initialization
    case tabs(Tabs.State)
    case onboarding(Onboarding.Splash.State)
  }

  public enum Action: Equatable {
    case initialization(Initialization.Action)
    case tabs(Tabs.Action)
    case onboarding(Onboarding.Splash.Action)
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
        state = .onboarding(.init())
        return .none

      case .onboarding(.forParent(.pressedLearn)):
        state = .tabs(
          .init(
            initialTab: .learn,
            cameraTab: .init(vision: .deutan),
            imagesTab: .init(),
            learnTab: .init(vision: .deutan)
          )
        )
        return .none

      case .onboarding(.forParent(.pressedCamera)):
        state = .tabs(
          .init(
            initialTab: .camera,
            cameraTab: .init(vision: .deutan),
            imagesTab: .init(),
            learnTab: .init(vision: .deutan)
          )
        )
        return .none

      case .tabs, .initialization, .onboarding:
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
    Scope(
      state: /State.onboarding,
      action: /Action.onboarding,
      Onboarding.Splash.init
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
        CaseLet(
          state: /State.onboarding,
          action: Action.onboarding,
          then: { store in
            Color.clear
              .toolbar { ToolbarItem { Color.clear } }
              .sheet(isPresented: .constant(true)) {
                Onboarding.Splash.Screen(store: store)
              }
          }
        )
      }
    }
  }
}
