import SwiftUI

extension Color {
#if os(iOS)
  public static let app: App = .iOS
#elseif os(macOS)
  public static let app: App = .macOS
#endif
  public struct App {
    public let systemBackground: Color
  }
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
