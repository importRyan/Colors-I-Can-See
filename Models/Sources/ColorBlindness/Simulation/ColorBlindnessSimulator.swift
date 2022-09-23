// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import simd

typealias Simulation = (_ input: RGBVector, _ severity: Double) -> RGBVector

/// Uses [Machado et al](https://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html) to simulate color blindness. Uses a grayscale transformation to simulate all forms of monochromacy.
///
public struct ColorBlindnessSimulator: ColorBlindnessSimulation {

  private static let simulations: [VisionType: Simulation] = [
    .deutan : MachadoTransforms.deutan,
    .protan : MachadoTransforms.protan,
    .tritan : MachadoTransforms.tritan,
    .monochromat : MonochromacyApproximationTransforms.generalized
  ]

  public init() {}

  public func simulate(_ vision: VisionType, severity: Double = 1, for color: RGBVector) -> RGBVector {
    if severity == 0 {
      return color
    }
    return Self.simulations[vision]?(color, severity) ?? color
  }
}
