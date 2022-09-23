// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

extension Color {

  public var vector: RGBAVector? {
    guard
      let color = self.cgColor?.convertedToSRGB(),
      let components = color.components?.map(ColorChannel.init)
    else { return nil }

    print("RGBAVector:", components)

    if color.numberOfComponents == 2 {
      return .init(.init(repeating: components[0]), components[1])
    }

    if color.numberOfComponents == 4 {
      return .init(components[0], components[1], components[2], components[3])
    }

    return nil
  }

  public init(vector: RGBVector, alpha: ColorChannel = 1) {
    self.init(vector: .init(vector, alpha))
  }

  public init(vector: RGBAVector) {
    // Using the standard Color channels initializer there can be some rounding error introduced that rounds 255 input to 254. Similar floors are applied to other values. NSColor does not share the same problems.
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    self.init(
      NSColor(
        srgbRed: CGFloat(vector.r),
        green: CGFloat(vector.g),
        blue: CGFloat(vector.b),
        alpha: CGFloat(vector.alpha)
      ))
#else
    self.init(
      UIColor(
        red: CGFloat(vector.r),
        green: CGFloat(vector.g),
        blue: CGFloat(vector.b),
        alpha: CGFloat(vector.alpha)
      ))
#endif
  }
}

fileprivate extension CGColor {

  func convertedToSRGB() -> CGColor? {

    guard let space = self.colorSpace else {
      return nil
    }

    if space == srgbSpace || space == esrgbSpace {
      return self
    }

    return self.converted(
      to: esrgbSpace,
      intent: .absoluteColorimetric,
      options: nil
    )
  }
}

fileprivate var esrgbSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!
fileprivate var srgbSpace = CGColorSpace(name: CGColorSpace.sRGB)!
