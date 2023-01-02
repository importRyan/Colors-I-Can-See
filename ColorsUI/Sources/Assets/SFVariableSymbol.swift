// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

public struct SFVariableSymbol {
  public init(symbol: SFVariableSymbol.Symbol, variableValue: Double) {
    self.symbol = symbol
    self.variableValue = variableValue
  }

  public let symbol: Symbol
  public var variableValue: Double

  public enum Symbol: String, CaseIterable {
    case target = "target"
  }
}

extension SFVariableSymbol {
  public var accessibilityLabel: String {
    switch symbol {
    case .target: return "Goal"
    }
  }
}

extension SFVariableSymbol: View, AccessibilityLabeledImage {

  public var image: ModifiedContent<Image, AccessibilityAttachmentModifier> {
    Image(systemName: symbol.rawValue, variableValue: variableValue)
      .accessibilityLabel(accessibilityLabel)
  }

  public var body: some View {
    self.image
  }
}
