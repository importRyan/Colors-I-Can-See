// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

struct NoMovementButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.8 : 1)
  }
}
