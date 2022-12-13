// Copyright 2022 by Ryan Ferrell. @importRyan

import CameraFlow
import ColorsUI
import ColorVision
import ComposableArchitecture
import Onboarding

public struct Root: ReducerProtocol {

  public init() {}

  public enum State: Equatable, Hashable {
    case camera(CameraFlow.Coordinator.State)
    case initialization
    case onboarding(OnboardingFlow.Coordinator.State)
  }

  public enum Action: Equatable {
    case camera(CameraFlow.Coordinator.Action)
    case initialization(Initialization.Action)
    case onboarding(OnboardingFlow.Coordinator.Action)
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
        state = .onboarding(.initialState())
        return .none

      case let .onboarding(.send(.advanceToCamera(vision))):
        state = .camera(
          .initialState(settings: .init(vision: vision))
        )
        return .none

      case .camera, .initialization, .onboarding:
        return .none
      }
    }
  }

  // MARK: - Glue

  @ReducerBuilder<State, Action>
  private var screens: some ReducerProtocol<State, Action> {
    Scope(
      state: /State.initialization,
      action: /Action.initialization,
      Initialization.init
    )
    Scope(
      state: /State.onboarding,
      action: /Action.onboarding,
      OnboardingFlow.Coordinator.init
    )
    Scope(
      state: /State.camera,
      action: /Action.camera,
      CameraFlow.Coordinator.init
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
          state: /State.camera,
          action: Action.camera,
          then: CameraFlow.init
        )
        CaseLet(
          state: /State.initialization,
          action: Action.initialization,
          then: Initialization.Screen.init
        )
        CaseLet(
          state: /State.onboarding,
          action: Action.onboarding,
          then: OnboardingFlow.init
        )
      }
    }
  }
}
