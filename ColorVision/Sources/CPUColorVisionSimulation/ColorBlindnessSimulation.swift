// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVectors
import Foundation
import simd
import SwiftUI
import VisionType

public protocol ColorBlindnessSimulation {
  func simulate(_ vision: VisionType, severity: Double, for color: RGBVector) -> RGBVector
}

extension ColorBlindnessSimulation {

  public func simulate(_ vision: VisionType, severity: Double, for color: Color) -> Color? {
    guard let vector = color.vector else {
      return nil
    }
    let simulated = self.simulate(vision, severity: severity, for: vector.rgb)
    return .init(vector: .init(simulated, vector.alpha))
  }
}

extension ColorBlindnessSimulation where Self == MachadoColorBlindnessSimulator {
  public static var standard: Self { MachadoColorBlindnessSimulator() }
}
