// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsFoundation

public enum ComparisonStyle: String, CaseIterable, SelfIdentifiable {
  case carousel
  case hoverPortal
  case miniMapLightTable
  case sideBySideHorizontal
  case sideBySideVertical
}

extension ComparisonStyle {
  public var localizedName: String {
    switch self {
    case .carousel: return "Carousel"
    case .hoverPortal: return "Hover"
    case .miniMapLightTable: return "Mini Map"
    case .sideBySideHorizontal: return "Horizontal"
    case .sideBySideVertical: return "Vertical"
    }
  }
}

