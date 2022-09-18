// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

extension ColorBlindnessSimulation {

  public func simulate(_ vision: VisionType, severity: Double, for color: Color) -> Color? {
    guard let vector = color.vector else {
      return nil
    }
    let simulated = self.simulate(vision, severity: severity, for: vector.rgb)
    return .init(vector: .init(simulated, vector.alpha))
  }
}
