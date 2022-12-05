// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import ComposableArchitecture
import Models

extension VisionTypes {

  public struct Screen: View {

    public init(store: StoreOf<VisionTypes>) {
      self.store = store
    }

    private let store: StoreOf<VisionTypes>
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
struct VisionTypesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      VisionTypes.Screen(
        store: .init(
          initialState: .init(),
          reducer: VisionTypes()
        )
      )
    }
  }
}
#endif
