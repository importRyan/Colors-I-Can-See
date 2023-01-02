// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA

extension ImageComparison {

  public struct Screen: View {

    public init(store: StoreOf<ImageComparison>) {
      self.store = store
    }

    private let store: StoreOf<ImageComparison>

    public var body: some View {
      ScrollView {
      }
      .onAppear { ViewStore(store.stateless).send(.onAppear) }
    }
  }
}
