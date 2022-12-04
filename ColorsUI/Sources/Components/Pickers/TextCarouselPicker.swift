// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct TextCarouselPicker<
  E: CaseIterable & Hashable & Identifiable
>: View {

  public init(
    selection: Binding<E>,
    onSwipeLeft: @escaping () -> Void,
    onSwipeRight: @escaping () -> Void,
    elements: [E] = E.allCases.map { $0 },
    label: KeyPath<E, String>,
    spacing: CGFloat
  ) {
    self.elements = elements
    self.label = label
    self.onSwipeLeft = onSwipeLeft
    self.onSwipeRight = onSwipeRight
    _selection = selection
    self.spacing = spacing
  }

  private let elements: [E]
  private let label: KeyPath<E, String>
  private let onSwipeLeft: () -> Void
  private let onSwipeRight: () -> Void
  @Binding private var selection: E
  private let spacing: CGFloat

  public var body: some View {
    FadedCarouselPicker(
      selection: $selection,
      label: buildTextButton,
      elements: elements,
      spacing: spacing
    )
    .fixedSize(horizontal: false, vertical: true)
  }

  private func buildTextButton(_ element: E) -> some View {
    Button(
      action: {
        withAnimation(.easeInOut(duration: 0.25)) {
          selection = element
        }
      },
      label: {
        Text(element[keyPath: label])
          .lineLimit(1)
          .fixedSize(horizontal: true, vertical: true)
          .foregroundStyle(selection == element ? Color.accentColor : .secondary)
          .padding(.vertical)
          .contentShape(Rectangle())
      }
    )
    .buttonStyle(NoMovementButtonStyle())
  }
}
