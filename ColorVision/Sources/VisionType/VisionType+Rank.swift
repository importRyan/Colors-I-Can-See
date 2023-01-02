// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Foundation

extension VisionType {

  public static let leastCommon = Self.monochromat
  public static let mostCommon = Self.typical

  public var rank: Int {
    switch self {
    case .typical: return 0
    case .deutan: return 1
    case .protan: return 2
    case .tritan: return 3
    case .monochromat: return 4
    }
  }

  public init?(rank: Int) {
    if let known = Self.allColorBlindCases.first(where: { $0.rank == rank }) {
      self = known
    } else {
      return nil
    }
  }

  public func nextMoreCommonVision() -> Self {
    Self(rank: self.rank - 1) ?? Self.mostCommon
  }

  public func nextLessCommonVision() -> Self {
    Self(rank: self.rank + 1) ?? Self.leastCommon
  }

  @discardableResult
  public mutating func moreCommon() -> Self {
    Self(rank: self.rank - 1) ?? Self.mostCommon
  }

  @discardableResult
  public mutating func lessCommon() -> Self {
    Self(rank: self.rank + 1) ?? Self.leastCommon
  }
}
