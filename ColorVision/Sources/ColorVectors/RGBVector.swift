// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import simd

public typealias ColorChannel = Float32
public typealias RGBVector = SIMD3<ColorChannel>
public typealias RGBAVector = SIMD4<ColorChannel>

public extension SIMD4<ColorChannel> {
  var rgb: SIMD3<ColorChannel> {
    .init(r, g, b)
  }
  var r: ColorChannel { x }
  var g: ColorChannel { y }
  var b: ColorChannel { z }
  var alpha: ColorChannel { w }
}
