// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import SwiftUI

extension VisionType {
  public var primaryColor: Color {
    switch self {
    case .typical: return .primary
    case .deutan: return .blue
    case .protan: return .blue
    case .tritan: return .pink
    case .monochromat: return .gray
    }
  }

  public var secondaryColor: Color {
    switch self {
    case .typical: return .secondary
    case .deutan: return .yellow
    case .protan: return .yellow
    case .tritan: return .teal
    case .monochromat: return .gray.opacity(0.5)
    }
  }

  public var textColor: Color {
    switch self {
    case .typical: return .primary
    case .deutan: return .yellow
    case .protan: return .yellow
    case .tritan: return .teal
    case .monochromat: return .gray
    }
  }
}
