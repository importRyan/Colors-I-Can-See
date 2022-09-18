// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import SwiftUI

public struct HueSimulation: View {

  public init(hideSimulation: Binding<Bool>, vision: VisionType) {
    _hideSimulation = hideSimulation
    self.vision = vision
  }

  @Binding var hideSimulation: Bool
  let vision: VisionType

  public var body: some View {
    simulatedVisionGradient
      .overlay {
        if hideSimulation {
          typicalVisionGradient
            .transition(.opacity)
        }
      }
      .drawingGroup(opaque: true, colorMode: .extendedLinear)
  }

  private var simulatedVisionGradient: AngularGradient {
    AngularGradient(
      gradient: Gradient.rainbow(in: vision),
      center: .center,
      startAngle: .degrees(-90),
      endAngle: .degrees(360 - 90)
    )
  }

  private var typicalVisionGradient: AngularGradient {
    AngularGradient(
      gradient: .rainbow(in: .typical),
      center: .center,
      startAngle: .degrees(-90),
      endAngle: .degrees(360 - 90)
    )
  }
}
