// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation

extension RGBVector {
  func encodeGammaSRGB() -> Self {
    self
      .clamped(lowerBound: .zero, upperBound: .one)
      .map(\.srgbEncoded)
      .clamped(lowerBound: .zero, upperBound: .one)
  }

  func decodeGammaSRGB() -> Self {
    self
      .clamped(lowerBound: .zero, upperBound: .one)
      .map(\.srgbDecoded)
      .clamped(lowerBound: .zero, upperBound: .one)
  }
}


extension ColorChannel {
  var srgbDecoded: Self {
    if self > Gamma.k_04045 {
      let shiftedScaled = (self + Gamma.k_055) / Gamma.k1_055
      return pow(shiftedScaled, Gamma.k2_4)
    }
    return self / Gamma.k12_92
  }
  
  var srgbEncoded: Self {
    if self > Gamma.k_0031308 {
      let power = pow(self, Gamma.k_416x)
      return Gamma.k1_055 * power - Gamma.k_055
    }
    return self * Gamma.k12_92
  }
  
  struct Gamma {
    static let k_04045: ColorChannel = 0.04045
    static let k12_92: ColorChannel = 12.92
    static let k_055: ColorChannel = 0.055
    static let k1_055: ColorChannel = 1.055
    static let k2_4: ColorChannel = 2.4
    
    static let k_0031308: ColorChannel = 0.0031308
    static let k_416x: ColorChannel = 0.41666666666
  }
}

extension RGBVector {
  func map(_ transform: (Scalar) -> Scalar) -> Self {
    .init(transform(self[0]), transform(self[1]), transform(self[2]))
  }
}
