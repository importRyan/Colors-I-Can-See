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

struct Strings {

  static let ctaLargeFont = String(
    localized: "Use Camera",
    comment: "Onboarding - Primary call to action button (large font size)"
  )

  static let cta = String(
    localized: "Explore by Camera",
    comment: "Onboarding - Primary call to action button (regular font size)"
  )
}

