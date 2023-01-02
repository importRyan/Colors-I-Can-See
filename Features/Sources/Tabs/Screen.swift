// Copyright 2022 by Ryan Ferrell. @importRyan

import Camera
import ColorsUI
import Onboarding
import TCA

extension Tabs {

  public struct Screen: View {

    public init(store: StoreOf<Tabs>) {
      self.store = store
    }

    private let store: StoreOf<Tabs>

    public var body: some View {
      WithViewStore(store.scope(state: \.currentTab)) { viewStore in
        TabView(selection: viewStore.binding(
          get: { $0 },
          send: Tabs.Action.selectTab
        )) {
          learnTab
          cameraTab
          imageTab
        }
      }
    }

    private var learnTab: some View {
      OnboardingFlow(
        store: store.scope(
          state: \.learnTab,
          action: Action.learn
        )
      )
      .tag(Tab.learn)
      .tabItem { CLabel("Learn", symbol: .learn) }
      .toolbarBackground(.visible, for: .tabBar)
      .toolbarBackground(.bar, for: .tabBar)
    }

    private var cameraTab: some View {
      Camera.Screen(
        store: store.scope(
          state: \.cameraTab,
          action: Action.camera
        )
      )
      .tag(Tab.camera)
      .tabItem { CLabel("Camera", symbol: .camera) }
      .toolbarBackground(.visible, for: .tabBar)
      .toolbarBackground(Material.ultraThin, for: .tabBar)
    }

    private var imageTab: some View {
      VStack { }
        .tag(Tab.image)
        .tabItem { CLabel("Images", symbol: .image) }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.bar, for: .tabBar)
    }
  }
}
