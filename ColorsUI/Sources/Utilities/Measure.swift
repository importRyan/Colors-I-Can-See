// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct Measure<Key: PreferenceKey>: View {

  public init(
    _ transform: @escaping (_ value: inout Key.Value, _ geometry: GeometryProxy) -> Void
  ) {
    self.transform = transform
  }

  private let transform: (inout Key.Value, GeometryProxy) -> Void

  public var body: some View {
    GeometryReader { proxy in
      Color.clear
        .transformPreference(Key.self) { transform(&$0, proxy) }
    }
  }
}
