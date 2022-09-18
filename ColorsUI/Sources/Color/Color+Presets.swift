// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

extension Color {

  public struct App {
    public let cardBorder = Color("CardBorder", bundle: .module)
    public let shadow = Color("Shadow", bundle: .module)
    public let systemBackground: Color
  }

#if os(iOS)
  public static let app: App = .iOS
#elseif os(macOS)
  public static let app: App = .macOS
#endif

}

extension Color.App {
#if os(iOS)

  static let iOS = Color.App(
    systemBackground: .init(uiColor: .systemBackground)
  )

#elseif os(macOS)

  static let macOS = Color.App(
    systemBackground: .init(nsColor: .windowBackgroundColor)
  )

#endif
}
