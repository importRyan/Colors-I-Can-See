// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import SwiftUI

public enum VisionType: Int, CaseIterable {
  case typical, deutan, protan, tritan, monochromat

  public static let allColorBlindCases: [Self] = [
    .deutan, .protan, .tritan, .monochromat
  ]
}

extension VisionType: Identifiable {
  public var id: Self { self }
}

extension VisionType {
  public var rank: Int {
    self.rawValue
  }
  public func nextMoreCommonVision() -> Self {
    Self(rawValue: self.rawValue - 1) ?? .typical
  }
  public func nextLessCommonVision() -> Self {
    Self(rawValue: self.rawValue + 1) ?? .monochromat
  }
  public mutating func moreCommon() -> Self {
    Self(rawValue: self.rawValue - 1) ?? .typical
  }
  public mutating func lessCommon() -> Self {
    Self(rawValue: self.rawValue + 1) ?? .monochromat
  }
}

extension VisionType {
  public var localizedInfo: LocalizedInformation {
    switch self {
    case .typical: return .typical
    case .deutan: return .deutan
    case .protan: return .protan
    case .tritan: return .tritan
    case .monochromat: return .monochromacy
    }
  }
}
extension VisionType {

  public struct LocalizedInformation {
    public let colloquialType: String?
    public let explanation: String
    public let frequency: (men: Double, women: Double)
    public let fullIntensityName: String
    public let shortName: String
  }
}

extension VisionType.LocalizedInformation {

  static let typical = Self.init(
    colloquialType: nil,
    explanation: String(
      localized: "Most of us see the world with three (some even four) cones that interpret wavelengths of light.",
      comment: "Typical Vision - Details"
    ),
    frequency: (men: 0.92, women: 0.99),
    fullIntensityName: String(
      localized: "Typical",
      comment: "Typical Vision - Full Intensity Name"
    ),
    shortName: String(
      localized: "Typical",
      comment: "Typical Vision - Short Name"
    )
  )

  static let deutan = Self.init(
    colloquialType: String(
      localized: "Red-Green",
      comment: "Deutan Vision - Colloquial Type"
    ),
    explanation: String(
      localized: "Fewer or atypical medium-wavelength \"green\" cones disguise reds and greens, but also yellows, oranges, and purples.",
      comment: "Deutan Vision - Details"
    ),
    frequency: (men: 0.06, women: 0.004),
    fullIntensityName: String(
      localized: "Deuteranopia",
      comment: "Deutan Vision - Full Intensity Name"
    ),
    shortName: String(
      localized: "Deutan",
      comment: "Deutan Vision - Short Name"
    )
  )

  static let protan = Self.init(
    colloquialType: String(
      localized: "Red-Green",
      comment: "Protan Vision - Colloquial Type"
    ),
    explanation: String(
      localized: "Green cones are absent ",
      comment: "Protan Vision - Details"
    ),
    frequency: (men: 0.025, women: 0.0005),
    fullIntensityName: String(
      localized: "Protanopia",
      comment: "Protan Vision - Full Intensity Name"
    ),
    shortName: String(
      localized: "Protan",
      comment: "Protan Vision - Short Name"
    )
  )

  static let tritan = Self.init(
    colloquialType: String(
      localized: "Blue-Yellow",
      comment: "Tritan Vision - Colloquial Type"
    ),
    explanation: String(
      localized: "Something special and descriptive.",
      comment: "Tritan Vision - Details"
    ),
    frequency: (men: 0.01, women: 0.04),
    fullIntensityName: String(
      localized: "Tritanopia",
      comment: "Tritan Vision - Full Intensity Name"
    ),
    shortName: String(
      localized: "Tritan",
      comment: "Tritan Vision - Short Name"
    )
  )

  static let monochromacy = Self.init(
    colloquialType: String(
      localized: "Mostly Rods",
      comment: "Monochromatic Vision - Colloquial Type"
    ),
    explanation: String(
      localized: "Many forms of monochromatic vision exist, relying on rods and possibly one type of cone color receptor.",
      comment: "Monochromatic Vision - Details"
    ),
    frequency: (men: 0.003, women: 0.003),
    fullIntensityName: String(
      localized: "Achromatopsia",
      comment: "Monochromatic Vision - Full Intensity Name"
    ),
    shortName: String(
      localized: "Monochromat",
      comment: "Monochromatic Vision - Short Name"
    )
  )
}
