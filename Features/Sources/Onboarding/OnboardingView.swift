// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

public struct OnboardingView: View {

  public init() {
  }

  @State var selectedVision = VisionType.deutan

  private let explicitSelectionAnimation = Animation.spring()

  public var body: some View {
    VStack {

      VStack(alignment: .leading, spacing: 15) {
        Text("Color blindness types")
          .font(.title.weight(.bold))
          .padding(.top, 30)
          .padding(.leading, 20)


        IfItFits(in: .horizontal) {
          OneLinePicker(
            cases: VisionType.allColorBlindCases,
            label: \.localizedInfo.shortName,
            selection: $selectedVision,
            animation: explicitSelectionAnimation
          )
          .padding(.leading, 20)
        }

        VisionInfoCardCarousel(
          explicitSelectionAnimation: explicitSelectionAnimation,
          selectedVision: $selectedVision
        )
      }
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      VStack {
        StartCameraButton(
          action: { }
        )
      }
      .scenePadding([.horizontal, .bottom])
    }
  }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      OnboardingView()
    }
  }
}
#endif
