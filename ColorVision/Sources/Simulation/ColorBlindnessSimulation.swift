// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import simd

public protocol ColorBlindnessSimulation {
  func simulate(_ vision: VisionType, severity: Double, for color: RGBVector) -> RGBVector
}

extension ColorBlindnessSimulation where Self == ColorBlindnessSimulator {
  public static var standard: Self { ColorBlindnessSimulator() }
}
