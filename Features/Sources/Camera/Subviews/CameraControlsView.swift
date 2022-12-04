// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

struct CameraControlsView: View {
  @Binding var simulation: VisionType

  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(spacing: 20) {
        TriggerButton()
//        SwipeMenu(simulation: $simulation)

        VStack(alignment: .center) {
          TextCarouselPicker(
            selection: $simulation,
            onSwipeLeft: { $simulation.wrappedValue.moreCommon() },
            onSwipeRight: { $simulation.wrappedValue.lessCommon() },
            label: \.localizedInfo.shortName.localizedUppercase,
            spacing: 15.0
          )
          .accentColor(.yellow)
          .font(.callout.weight(.medium))
          .fixedSize(horizontal: false, vertical: true)
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.bottom, 50)
    .preferredColorScheme(.dark)
  }
}
