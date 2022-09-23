// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation

/// Hue is defined as 0...1
public struct HSV: Equatable {

  /// Defined as 0...1 rather than in degrees
  public var hue: ColorChannel

  /// 0...1
  public var sat: ColorChannel

  /// 0...1
  public var val: ColorChannel

  public init(_ hue01: ColorChannel, _ saturation: ColorChannel, _ value: ColorChannel) {
    self.hue = hue01 == 1 ? 0 : hue01
    self.sat = saturation
    self.val = value
  }

  public static let zero = HSV(0, 0, 0)
}

import SwiftUI

extension Color {
  public init(hsv: HSV) {
    self.init(
      hue: Double(hsv.hue),
      saturation: Double(hsv.sat),
      brightness: Double(hsv.val)
    )
  }
}

extension RGBVector {
  /// Assuming 0...1 clamped values
  public init(hsv: HSV) {
    let chroma = hsv.val * hsv.sat
    let _hue = abs(1 - hsv.hue) * 6 // coming from 0...1
    let x = chroma * (1 - abs(trueModulo(dividend: _hue, divisor: 2) - 1))

    var r = ColorChannel(0)
    var g = ColorChannel(0)
    var b = ColorChannel(0)

    switch _hue {
    case 0...1:
      r = chroma
      b = x
    case ...2:
      r = x
      b = chroma
    case ...3:
      b = chroma
      g = x
    case ...4:
      b = x
      g = chroma
    case ...5:
      r = x
      b = 0
      g = chroma
    case ...6:
      r = chroma
      b = 0
      g = x
    default: break
    }

    let m = hsv.val - chroma
    r += m
    g += m
    b += m

    self.init(r, g, b)
  }
}

fileprivate func trueModulo(dividend: ColorChannel, divisor: ColorChannel) -> ColorChannel {
  let r = dividend.remainder(dividingBy: divisor)
  return r >= 0 ? r : r + divisor
}
