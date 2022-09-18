// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI

struct StartCameraButton: View {
  let action: () -> Void

  var body: some View {
    ViewThatFits(in: .horizontal) {
      LargeCTAButton(Strings.cta, action: action)
      LargeCTAButton(Strings.ctaLargeFont, action: action)
    }
  }
}

extension StartCameraButton {
  fileprivate struct Strings {
    static let ctaLargeFont = String(
      localized: "VisionTypes.StartCamera.CTALargeFont",
      defaultValue: "Use Camera",
      bundle: .module
    )

    static let cta = String(
      localized: "VisionTypes.StartCamera.CTA",
      defaultValue: "Explore by Camera",
      bundle: .module
    )
  }
}
