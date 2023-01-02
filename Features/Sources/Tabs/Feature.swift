// Copyright 2022 by Ryan Ferrell. @importRyan

import Camera
import Onboarding
import TCA

public struct Tabs: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public var currentTab: Tab
    public var cameraTab: Camera.State
    public var learnTab: OnboardingFlow.Coordinator.State

    public init(
      initialTab: Tab,
      cameraTab: Camera.State,
      learnTab: OnboardingFlow.Coordinator.State
    ) {
      self.currentTab = initialTab
      self.cameraTab = cameraTab
      self.learnTab = learnTab
    }
  }

  public enum Action: Equatable {
    case selectTab(Tab)
    case learn(OnboardingFlow.Coordinator.Action)
    case camera(Camera.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    screens
    coordinator
  }

  public var coordinator: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.currentTab = tab
        return .none

      case .camera, .learn:
        return .none
      }
    }
  }

  @ReducerBuilder<State, Action>
  private var screens: some ReducerProtocol<State, Action> {
    Scope(
      state: \.learnTab,
      action: /Action.learn,
      OnboardingFlow.Coordinator.init
    )
    Scope(
      state: \.cameraTab,
      action: /Action.camera,
      Camera.init
    )
  }
}

extension Tabs {
  public enum Tab {
    case learn, camera, image
  }
}
