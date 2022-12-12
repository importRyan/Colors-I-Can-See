// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import simd

/// I am not aware of research for a "realistic" monochromatic vision simulator. If anything, it seems logical for colors to appear much brighter, as rods are more sensitive to light than cones. Rods also have different spectral responses that would be masked by cone excitation in the definitions of XYZ and LMS color spaces, so I'm not sure how realistic the approaches below may be.
///
/// Canonical luminance: gamma decode, dot product
/// Adheres to the R library Colorspace's simulation, which uses XYZ Y luminance desaturation.
/// For 66 133 244: reports 135/6 (same as Colorspace)
///
/// Both Firefox and Google simulate a little brighter, with Firefox using NTSA luma (i.e., NTSC constants without gamma decoding).
///
struct MonochromacyApproximationTransforms {
  static let generalized: Simulation = { input, _ -> RGBVector in
    let linear = input.decodeGammaSRGB()
    let xyz_linearRGB_Y = simd_float3(0.2126, 0.7152, 0.0722)
    let xyz_y = simd_dot(xyz_linearRGB_Y, linear)
    return .init(repeating: xyz_y.srgbEncoded)
  }
}
