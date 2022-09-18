// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import SwiftUI

public enum VisionType: Int, CaseIterable {
  case typical, deutan, protan, tritan, monochromat
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
  public var localizedShortName: String {
    switch self {
    case .typical:
      return String(
        localized: "Typical",
        comment: "Vision Types - Short name"
      )
    case .deutan:
      return String(
        localized: "Deutan",
        comment: "Vision Types - Short name"
      )
    case .protan:
      return String(
        localized: "Protan",
        comment: "Vision Types - Short name"
      )
    case .tritan:
      return String(
        localized: "Tritan",
        comment: "Vision Types - Short name"
      )
    case .monochromat:
      return String(
        localized: "Monochromat",
        comment: "Vision Types - Short name"
      )
    }
  }

  public var localizedFullName: String {
    switch self {
    case .typical:
      return String(
        localized: "Typical",
        comment: "Vision Types - Full Name"
      )
    case .deutan:
      return String(
        localized: "Deutanopia",
        comment: "Vision Types - Full Name"
      )
    case .protan:
      return String(
        localized: "Protanopia",
        comment: "Vision Types - Full Name"
      )
    case .tritan:
      return String(
        localized: "Tritanopia",
        comment: "Vision Types - Full Name"
      )
    case .monochromat:
      return String(
        localized: "Monochromacy",
        comment: "Vision Types - Full Name"
      )
    }
  }
}
