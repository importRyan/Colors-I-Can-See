// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVectors
import ColorBlindnessTransforms
import Foundation
import simd
import VisionType

/// Uses [Machado et al](https://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html) to simulate color blindness. Uses a grayscale transformation to simulate all forms of monochromacy.
///
public struct MachadoColorBlindnessSimulator: ColorBlindnessSimulation {

  public init() {}

  public func simulate(_ vision: VisionType, severity: Double = 1, for color: RGBVector) -> RGBVector {
    if severity == 0 {
      return color
    }
    return Self.simulations[vision]?(color, severity) ?? color
  }

  private static let simulations: [VisionType: (_ input: RGBVector, _ severity: Double) -> RGBVector] = [
    .deutan : MachadoTransforms.deutan,
    .protan : MachadoTransforms.protan,
    .tritan : MachadoTransforms.tritan,
    .monochromat : MonochromacyApproximationTransforms.generalized
  ]
}
