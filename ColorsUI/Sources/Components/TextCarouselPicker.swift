// Copyright 2022 by Ryan Ferrell. @importRyan

import OrderedCollections
import SwiftUI

// MARK: - Picker
public struct TextCarouselPicker<T: CaseIterable & Hashable & Identifiable>: View {

  public init(
    selection: Binding<T>,
    label: KeyPath<T, String>,
    orderedChoices: Array<T> = T.allCases.map { $0 },
    spacing: CGFloat
  ) {
    self.choices = orderedChoices
    self.label = label
    self.spacing = spacing
    _selection = selection
    _widths = State(
      initialValue:
        OrderedDictionary(
          uncheckedUniqueKeys: orderedChoices,
          values: Array(repeating: 0, count: choices.count)
        )
    )
  }

  private let choices: Array<T>
  private let label: KeyPath<T, String>
  @Binding
  private var selection: T

  @State
  private var widths: OrderedDictionary<AnyHashable, CGFloat>
  private let spacing: CGFloat

  public var body: some View {
    Color.clear
      .hidden()
      .overlay(alignment: .center) {
        alignedButtonsRow
          .frame(maxWidth: .infinity)
          .mask(horizontalMask)
          .accessibilityRepresentation {
            accessibilityRepresentation
          }
      }
  }
}

private extension TextCarouselPicker {

  var alignedButtonsRow: some View {
    HStack(alignment: .center, spacing: spacing) {
      ForEach(choices) { number in
        buildButton(number)
      }
    }
    .alignmentGuide(HorizontalAlignment.center) { d in
      d[HorizontalAlignment.leading] + alignedButtonsRowOffset
    }
    .onPreferenceChange(OrderedWidthsPreferenceKey.self) { newValue in
      withAnimation {
        widths.merge(newValue) { $1 }
      }
    }
  }

  var alignedButtonsRowOffset: CGFloat {
    let selectedIndex = widths.index(forKey: selection)!
    let buttonWidths = widths.elements.values[..<selectedIndex].reduce(0, +)
    // Zero-based (effectively: spacing * items.count - 1)
    let interButtonSpacing = spacing * CGFloat(selectedIndex)
    let centerOfCurrentSelection = widths.elements[selectedIndex].value / 2
    return buttonWidths + interButtonSpacing + centerOfCurrentSelection
  }

  func buildButton(_ choice: T) -> some View {
    Button(
      action: {
        withAnimation(.easeInOut(duration: 0.25)) {
          selection = choice
        }
      },
      label: {
        Text(choice[keyPath: label])
          .lineLimit(1)
          .fixedSize(horizontal: true, vertical: true)
          .foregroundStyle(selection == choice ? Color.accentColor : .secondary)
      }
    )
    .buttonStyle(NoMovementButtonStyle())
    .background {
      Measure<OrderedWidthsPreferenceKey> { value, geometry in
        value[choice] = geometry.size.width
      }
    }
  }

  var horizontalMask: some View {
    LinearGradient(
      stops: [
        .init(color: .black.opacity(0), location: 0.05),
        .init(color: .black.opacity(1), location: 0.25),
        .init(color: .black.opacity(1), location: 0.75),
        .init(color: .black.opacity(0), location: 0.95)
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  var accessibilityRepresentation: some View {
    Picker(selection: $selection) {
      ForEach(choices) { choice in
        Text(choice[keyPath: label])
          .tag(choice)
      }
    } label: {
      EmptyView()
    }
  }
}

fileprivate struct OrderedWidthsPreferenceKey: PreferenceKey {

  static var defaultValue: Dictionary<AnyHashable, CGFloat> = [:]

  static func reduce(
    value: inout Dictionary<AnyHashable, CGFloat>,
    nextValue: () -> Dictionary<AnyHashable, CGFloat>
  ) {
    value.merge(nextValue()) { $1 }
  }
}
