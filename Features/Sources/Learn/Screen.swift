// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import VisionType

extension LearnAboutVisionTypes {

  public struct Screen: View {

    public init(store: StoreOf<LearnAboutVisionTypes>) {
      self.store = store
    }

    private let store: StoreOf<LearnAboutVisionTypes>
    private let explicitSelectionAnimation = Animation.spring()

    public var body: some View {
      WithViewStore(store) { viewStore in
        VStack(alignment: .leading, spacing: 15) {
#if os(iOS)
          Text(Strings.headline)
            .font(.title2.weight(.bold))
            .padding(.top, 30)
            .padding(.leading, 20)
#endif

          IfItFits(in: .horizontal) {
            OneLinePicker(
              cases: VisionType.allColorBlindCases,
              label: \.localizedInfo.shortName,
              selection: viewStore.binding(\.$vision),
              animation: explicitSelectionAnimation
            )
            .padding(.leading, 20)
          }
#if os(macOS)
          .scenePadding(.top)
#endif

          VisionInfoCardCarousel(
            explicitSelectionAnimation: explicitSelectionAnimation,
            selectedVision: viewStore.binding(\.$vision)
          )
        }
      }
      .navigationTitle(Strings.headline)
    }
  }
}

extension LearnAboutVisionTypes.Screen {
  fileprivate struct Strings {
    static let headline = String(localized: "VisionTypes.Headline", bundle: .module)
  }
}

#if DEBUG
struct LearnAboutVisionTypesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LearnAboutVisionTypes.Screen(
        store: .init(
          initialState: .init(),
          reducer: LearnAboutVisionTypes()
        )
      )
    }
  }
}
#endif
