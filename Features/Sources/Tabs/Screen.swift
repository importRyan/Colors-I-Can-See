// Copyright 2022 by Ryan Ferrell. @importRyan

import Camera
import ColorsUI
import Images
import Learn
import TCA

extension Tabs {

  public struct Screen: View {

    public init(store: StoreOf<Tabs>) {
      self.store = store
    }

    private let store: StoreOf<Tabs>

#if os(iOS)
    // Bottom tab bar style
    public var body: some View {
      WithViewStore(store.scope(state: \.currentTab)) { viewStore in
        TabView(selection: viewStore.binding(
          get: { $0 },
          send: Tabs.Action.selectTab
        )) {
          learnTab
            .tag(Tab.learn)
            .tabItem(Tab.learn.label)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.bar, for: .tabBar)
          cameraTab
            .tag(Tab.camera)
            .tabItem(Tab.camera.label)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Material.ultraThin, for: .tabBar)
          imageTab
            .tag(Tab.image)
            .tabItem(Tab.image.label)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.bar, for: .tabBar)
        }
      }
    }

#elseif os(macOS)
    // Toolbar button switches whole window hierarchy
    public var body: some View {
      SwitchStore(store.scope(state: \.currentTab)) {
        CaseLet(
          state: /Tab.learn,
          action: Action.learn,
          then: { _ in learnTab }
        )
        CaseLet(
          state: /Tab.camera,
          action: Action.camera,
          then: { _ in cameraTab }
        )
        CaseLet(
          state: /Tab.image,
          action: Action.learn,
          then: { _ in imageTab }
        )
      }
      .toolbar { MacTabSwitcher(store: store) }
    }
#endif
  }
}

// MARK: - Glue

extension Tabs.Screen {
  private var learnTab: some View {
    LearnAboutVisionTypes.Screen(
      store: store.scope(
        state: \.learnTab,
        action: Tabs.Action.learn
      )
    )
  }

  private var cameraTab: some View {
    Camera.Screen(
      store: store.scope(
        state: \.cameraTab,
        action: Tabs.Action.camera
      )
    )
  }

  private var imageTab: some View {
    ImagesCoordinator.Screen(
      store: store.scope(
        state: \.imagesTab,
        action: Tabs.Action.images
      )
    )
  }
}
