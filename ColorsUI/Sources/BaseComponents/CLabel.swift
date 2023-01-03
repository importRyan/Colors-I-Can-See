// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

public struct CLabel<Content: View, Icon: View>: View {

  public init(
    _ content: String,
    symbol: SFSymbol
  ) where Content == Text, Icon == SFSymbol {
    self.content = { Text(content) }
    self.icon = { symbol }
  }

  public init(
    _ content: Content,
    symbol: SFSymbol
  ) where Icon == SFSymbol {
    self.content = { content }
    self.icon = { symbol }
  }

  public init(
    _ content: String,
    symbol: SFVariableSymbol
  ) where Content == CText, Icon == SFVariableSymbol {
    self.content = { CText(content) }
    self.icon = { symbol }
  }

  public init(
    _ content: Content,
    symbol: SFVariableSymbol
  ) where Icon == SFVariableSymbol {
    self.content = { content }
    self.icon = { symbol }
  }

  public init(
    _ content: String,
    symbol: AccessibilityLabeledImage
  ) where Content == CText, Icon == ModifiedContent<Image, AccessibilityAttachmentModifier> {
    self.content = { CText(content) }
    self.icon = { symbol.image }
  }

  public init(
    _ content: Content,
    symbol: AccessibilityLabeledImage
  ) where Icon == ModifiedContent<Image, AccessibilityAttachmentModifier> {
    self.content = { content }
    self.icon = { symbol.image }
  }

  private let content: () -> Content
  private let icon: () -> Icon

  public var body: some View {
    Label(title: content, icon: icon)
  }
}
