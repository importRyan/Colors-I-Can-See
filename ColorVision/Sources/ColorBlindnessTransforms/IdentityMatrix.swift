// Copyright 2022 by Ryan Ferrell. @importRyan

import simd

extension simd_float3x3 {
  static let identity = simd_float3x3(rows: [
    SIMD3( 1.000000,    0.000000,    0.000000),
    SIMD3( 0.000000,    1.000000,    0.000000),
    SIMD3( 0.000000,    0.000000,    1.000000)
  ])
}
