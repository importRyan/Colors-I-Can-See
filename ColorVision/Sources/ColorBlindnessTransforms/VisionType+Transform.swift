// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import simd
import VisionType

extension VisionType {
  
  public var transform: simd_float3x3 {
    Self.matrices[self]!
  }

  private static let matrices: [VisionType: simd_float3x3] = [
    .typical: .identity,
    .protan: MachadoTransforms.protanMatrices[10]!,
    .deutan: MachadoTransforms.deutanMatrices[10]!,
    .tritan: MachadoTransforms.tritanMatrices[10]!,
    .monochromat: MonochromacyApproximationTransforms.matrixTransform
  ]
}
