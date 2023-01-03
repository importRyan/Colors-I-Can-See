// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct OneLinePicker<T: Hashable & Identifiable>: View {

  public init(
    cases: [T],
    label: KeyPath<T, String>,
    selection: Binding<T>,
    animation: Animation = .default
  ) {
    self.animation = animation
    self.cases = cases
    self.label = label
    _selection = selection
  }

  private let animation: Animation
  private let cases: [T]
  private let label: KeyPath<T, String>
  @Binding
  private var selection: T

  public var body: some View {
    HStack {
      ForEach(cases) { element in
        Button(element[keyPath: label]) {
          withAnimation(animation) {
            selection = element
          }
        }
        .lineLimit(1)
        .fixedSize(horizontal: false, vertical: true)
        .foregroundColor(selection == element ? .accentColor : .secondary)
        .buttonStyle(.borderless)
      }
      .font(.subheadline)
    }
  }
}
