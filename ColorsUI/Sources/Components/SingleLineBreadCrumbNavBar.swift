// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct SingleLineBreadCrumbNavBar<T: Hashable & Identifiable>: View {

  public init(
    cases: [T],
    label: KeyPath<T, String>,
    selection: Binding<T>
  ) {
    self.cases = cases
    self.label = label
    _selection = selection
  }

  private let cases: [T]
  private let label: KeyPath<T, String>
  @Binding
  private var selection: T

  public var body: some View {
    HStack {
      ForEach(cases) { element in
        Button(element[keyPath: label]) {
          withAnimation {
            selection = element
          }
        }
        .lineLimit(1)
        .fixedSize(horizontal: false, vertical: true)
        .foregroundColor(selection == element ? .accentColor : .secondary)
      }
      .font(.subheadline)
    }
  }
}
