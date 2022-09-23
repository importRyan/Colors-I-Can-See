// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import ComposableArchitecture
import Models

extension Onboarding {

  public struct Screen: View {

    public init() {
      self.store = .init(initialState: .init(), reducer: Onboarding.init())
    }

    private let store: StoreOf<Onboarding>
    private let explicitSelectionAnimation = Animation.spring()

    public var body: some View {
      WithViewStore(store) { viewStore in

        VStack(alignment: .leading, spacing: 15) {
          Text("Color blindness types")
            .font(.title2.weight(.bold))
            .padding(.top, 30)
            .padding(.leading, 20)

          IfItFits(in: .horizontal) {
            OneLinePicker(
              cases: VisionType.allColorBlindCases,
              label: \.localizedInfo.shortName,
              selection: viewStore.binding(\.$vision),
              animation: explicitSelectionAnimation
            )
            .padding(.leading, 20)
          }

          VisionInfoCardCarousel(
            explicitSelectionAnimation: explicitSelectionAnimation,
            selectedVision: viewStore.binding(\.$vision)
          )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
          VStack {
            StartCameraButton(
              action: { viewStore.send(.pressedStartCamera) }
            )
          }
          .scenePadding([.horizontal, .bottom])
        }
      }
    }
  }
}

#if DEBUG
struct OnboardingScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Onboarding.Screen()
    }
  }
}
#endif
