// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

extension Color {
  public init(hsv: HSV) {
    self.init(
      hue: Double(hsv.hue),
      saturation: Double(hsv.sat),
      brightness: Double(hsv.val)
    )
  }
}
