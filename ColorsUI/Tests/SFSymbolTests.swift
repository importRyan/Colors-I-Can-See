import XCTest
@testable import ColorsUI

final class SFSymbolTests: XCTestCase {
  func testRawValuesResolveToSystemNames() {
    for systemName in SFSymbol.allCases.map(\.rawValue) {
      #if os(macOS)
      let image = NSImage(systemSymbolName: systemName, accessibilityDescription: nil)
      #elseif os(iOS)
      let image = UIImage(systemName: systemName)
      #endif
      XCTAssertNotNil(image, systemName)
    }
  }
}

final class SFVariableSymbolTests: XCTestCase {
  func testRawValuesResolveToSystemNames() {
    for systemName in SFVariableSymbol.Symbol.allCases.map(\.rawValue) {
      #if os(macOS)
      let image = NSImage(systemSymbolName: systemName, variableValue: 0.33, accessibilityDescription: nil)
      #elseif os(iOS)
      let image = UIImage(systemName: systemName, variableValue: 0.33)
      #endif
      XCTAssertNotNil(image, systemName)
    }
  }
}
