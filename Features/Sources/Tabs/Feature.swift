// Copyright 2022 by Ryan Ferrell. @importRyan

import Camera
import ColorsFoundation
import Images
import Learn
import TCA

public struct Tabs: ReducerProtocol {

  public init() {}

  public enum Tab: CaseIterable, SelfIdentifiable {
    case learn, camera, image
  }

  public struct State: Equatable, Hashable {
    public var currentTab: Tab
    public var cameraTab: Camera.State
    public var learnTab: LearnAboutVisionTypes.State
    public var imagesTab: ImagesCoordinator.State

    public init(
      initialTab: Tab,
      cameraTab: Camera.State,
      imagesTab: ImagesCoordinator.State,
      learnTab: LearnAboutVisionTypes.State
    ) {
      self.currentTab = initialTab
      self.cameraTab = cameraTab
      self.imagesTab = imagesTab
      self.learnTab = learnTab
    }
  }

  public enum Action: Equatable {
    case selectTab(Tab)
    case learn(LearnAboutVisionTypes.Action)
    case camera(Camera.Action)
    case images(ImagesCoordinator.Action)
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

      case .camera, .images, .learn:
        return .none
      }
    }
  }

  @ReducerBuilder<State, Action>
  private var screens: some ReducerProtocol<State, Action> {
    Scope(
      state: \.learnTab,
      action: /Action.learn,
      LearnAboutVisionTypes.init
    )
    Scope(
      state: \.cameraTab,
      action: /Action.camera,
      Camera.init
    )
    Scope(
      state: \.imagesTab,
      action: /Action.images,
      ImagesCoordinator.init
    )
  }
}
