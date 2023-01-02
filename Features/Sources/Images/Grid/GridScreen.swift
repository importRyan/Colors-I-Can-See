// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA

extension ImageGrid {

  public struct Screen: View {

    public init(store: StoreOf<ImageGrid>) {
      self.store = store
    }

    private let store: StoreOf<ImageGrid>

    public var body: some View {
      ScrollView {

      }
      .navigationTitle("Images")
      .onAppear { ViewStore(store.stateless).send(.onAppear) }
    }
  }
}
