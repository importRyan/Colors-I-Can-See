// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import SwiftUI

public struct HSVRainbowWheel: View {
  var vision: VisionType

  public var body: some View {
    ZStack {
      Circle()
        .fill(
          AngularGradient(
            gradient: .rainbow(in: vision),
            center: .center
          )
        )
    }
    .animation(.easeOut(duration: 1), value: vision)
  }
}
