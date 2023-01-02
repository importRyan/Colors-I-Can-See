// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA

extension Tabs {
  struct MacTabSwitcher: ToolbarContent {

    let store: StoreOf<Tabs>

    var body: some ToolbarContent {
      ToolbarItem(placement: .navigation) {
        WithViewStore(store.scope(state: \.currentTab)) { viewStore in
          Picker(selection: viewStore.binding(get: { $0 }, send: Action.selectTab)) {
            ForEach(Tab.allCases) { tab in
              tab.label()
                .tag(tab)
                .labelStyle(TitleAndIconLabelStyle())
            }
          } label: {
            viewStore.state.label()
              .labelStyle(TitleAndIconLabelStyle())
          }
          .pickerStyle(.menu)
          .controlSize(.large)
        }
      }
    }
  }
}
