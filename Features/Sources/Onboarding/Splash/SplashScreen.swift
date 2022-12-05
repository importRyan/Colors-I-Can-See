// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import ComposableArchitecture

extension Splash {

  public struct Screen: View {

    public init(store: StoreOf<Splash>) {
      self.store = store
    }

    private let store: StoreOf<Splash>

    public var body: some View {
      WithViewStore(store) { viewStore in
        ZStack {
          HueSimulation(
            hideSimulation: .constant(false),
            vision: .deutan
          )
          .edgesIgnoringSafeArea(.all)
          .opacity(0.25)
          .background(Color.black)

          Text("Many of us see differently")
            .font(.largeTitle.weight(.black))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(.white)
            .blendMode(.lighten)
        }
        .safeAreaInset(edge: .bottom) {
          Button("Learn more") {
            viewStore.send(.pressedNext)
          }
        }
      }
    }
  }
}
