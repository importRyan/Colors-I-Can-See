// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import ComposableArchitecture

#warning("TODO: Create animated intro")
extension Splash {

  public struct Screen: View {

    public init(store: StoreOf<Splash>) {
      self.store = store
    }

    private let store: StoreOf<Splash>

    private let loop = Animation
      .easeIn(duration: 4)
      .repeatForever(autoreverses: true)
      .delay(0.25)

    public var body: some View {
      WithViewStore(store) { viewStore in
        ZStack {
          Color.black
            .edgesIgnoringSafeArea(.all)

          HueSimulation(
            hideSimulation: .constant(false),
            vision: .deutan
          )
          .edgesIgnoringSafeArea(.all)
          .opacity(viewStore.didAppear ? 0 : 0.5)
          .animation(loop, value: viewStore.didAppear)

          HueSimulation(
            hideSimulation: .constant(false),
            vision: .tritan
          )
          .edgesIgnoringSafeArea(.all)
          .opacity(viewStore.didAppear ? 0.5 : 0)
          .animation(loop, value: viewStore.didAppear)

          VStack {
            Text(Strings.headline)
              .font(.largeTitle.weight(.black))
              .lineLimit(nil)
              .fixedSize(horizontal: false, vertical: true)
              .foregroundColor(.white)
              .blendMode(.lighten)
              .opacity(0.85)
          }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
          LargeCTAButton(
            Strings.cta,
            action: { viewStore.send(.pressedNext) }
          )
          .scenePadding([.horizontal, .bottom])
        }
        .onAppear {
          if !viewStore.didAppear {
            viewStore.send(.onAppear)
          }
        }
      }
    }
  }
}

extension Splash {
  struct Strings {
    static let headline = String(
      localized: "Splash.Headline",
      defaultValue: "Many of use see differently",
      bundle: .module
    )
    static let cta = String(
      localized: "Splash.CTA",
      defaultValue: "Many of use see differently",
      bundle: .module
    )
  }
}
