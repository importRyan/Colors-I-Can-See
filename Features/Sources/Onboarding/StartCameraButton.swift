// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI

struct StartCameraButton: View {
  let action: () -> Void

  var body: some View {
    ViewThatFits(in: .horizontal) {
      Button(
        action: action,
        label: {
          Text(Strings.cta)
            .lineLimit(1)
            .font(.title3.weight(.medium))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.borderedProminent)

      Button(
        action: action,
        label: {
          Text(Strings.ctaLargeFont)
            .lineLimit(1)
            .font(.title3.weight(.medium))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.borderedProminent)
    }
  }

  private var label: some View {
    Text(Strings.cta)
      .font(.title3.weight(.medium))
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity)
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
