// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

struct VisionInfoCardCarousel: View {

  let explicitSelectionAnimation: Animation
  @Binding var selectedVision: VisionType

  var body: some View {
    GeometryReader { geo in
      VStack(alignment: .center) {
        CarouselPicker(
          selection: $selectedVision,
          label: { buildCard(for: $0, bounds: geo.size) },
          elements: VisionType.allColorBlindCases,
          spacing: 20
        )
      }
    }
    .padding(.vertical)
    .padding(.bottom, 40)
    .shadow(color: .primary.opacity(0.25), radius: 15, x: 8, y: 14)
  }

  private func buildCard(for element: VisionType, bounds: CGSize) -> some View {
    VisionCard(
      vision: element,
      carouselSize: bounds,
      onTap: {
        withAnimation(explicitSelectionAnimation) {
          selectedVision = element
        }
      }
    )
  }
}
