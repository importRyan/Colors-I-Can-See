// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

public struct OnboardingView: View {

  public init() {
  }

  @State var selectedVision = VisionType.deutan

  public var body: some View {
    ScrollView {

      VStack(alignment: .leading, spacing: 15) {
        Text("Color blindness types")
          .font(.title.weight(.bold))
          .padding(.top, 30)
          .padding(.leading, 20)


        IfFits(in: .horizontal) {
          SingleLineBreadCrumbNavBar(
            cases: VisionType.allColorBlindCases,
            label: \.localizedInfo.shortName,
            selection: $selectedVision
          )
          .padding(.leading, 20)
        }

        VStack(alignment: .center) {

          TextCarouselPicker(
            selection: $selectedVision,
            label: \.localizedInfo.shortName.localizedUppercase,
            spacing: 15.0
          )
          .accentColor(.yellow)
          .font(.caption.weight(.medium))
          .fixedSize(horizontal: false, vertical: true)
        }

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 20) {
            ForEach(VisionType.allColorBlindCases) { vision in
              VisionCard(vision: vision)
                .tag(vision)
            }
          }
          .padding(.leading, 20)
          .padding(.vertical)
          .padding(.bottom, 40)
          .shadow(color: .primary.opacity(0.25), radius: 15, x: 8, y: 14)
        }
        .fixedSize(horizontal: false, vertical: true)
      }
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      StartCameraButton(
        action: { }
      )
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
