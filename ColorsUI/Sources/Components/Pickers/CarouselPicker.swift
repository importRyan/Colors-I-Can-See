// Copyright 2022 by Ryan Ferrell. @importRyan

import OrderedCollections
import SwiftUI

// MARK: - Versions

public struct CarouselPicker<
  E: CaseIterable & Hashable & Identifiable,
  Label: View
>: View {

  public init(
    selection: Binding<E>,
    label: @escaping (E) -> Label,
    elements: Array<E> = E.allCases.map { $0 },
    spacing: CGFloat
  ) {
    self.buildLabel = label
    self.elements = elements
    self.selectedElement = selection
    self.spacing = spacing
  }

  private let buildLabel: (E) -> Label
  private let elements: Array<E>
  private var selectedElement: Binding<E>
  private let spacing: CGFloat

  public var body: some View {
    Color.clear
      .hidden()
      .overlay(alignment: .center) {
        _CarouselPicker(
          selection: selectedElement,
          label: buildLabel,
          elements: elements,
          spacing: spacing
        )
        .frame(maxWidth: .infinity, alignment: .top)
      }
  }
}

public struct FadedCarouselPicker<
  E: CaseIterable & Hashable & Identifiable,
  Label: View
>: View {

  public init(
    selection: Binding<E>,
    label: @escaping (E) -> Label,
    elements: Array<E> = E.allCases.map { $0 },
    spacing: CGFloat
  ) {
    self.buildLabel = label
    self.elements = elements
    self.selectedElement = selection
    self.spacing = spacing
  }

  private let buildLabel: (E) -> Label
  private let elements: Array<E>
  private var selectedElement: Binding<E>
  private let spacing: CGFloat

  public var body: some View {
    Color.clear
      .hidden()
      .overlay(alignment: .center) {
        _CarouselPicker(
          selection: selectedElement,
          label: buildLabel,
          elements: elements,
          spacing: spacing
        )
        .frame(maxWidth: .infinity)
        .fadeEdges(.horizontal)
      }
  }
}

// MARK: - Implementation

fileprivate struct _CarouselPicker<
  E: CaseIterable & Hashable & Identifiable,
  Label: View
>: View {

  init(
    selection: Binding<E>,
    label: @escaping (E) -> Label,
    elements: Array<E>,
    spacing: CGFloat
  ) {
    self.elements = elements
    self.buildLabel = label
    self.spacing = spacing
    _selectedElement = selection
    _widths = State(
      initialValue:
        OrderedDictionary(
          uncheckedUniqueKeys: elements,
          values: Array(repeating: 0, count: elements.count)
        )
    )
  }

  private let buildLabel: (E) -> Label
  private let elements: Array<E>
  @Binding private var selectedElement: E
  private let spacing: CGFloat

  @State private var widths: OrderedDictionary<AnyHashable, CGFloat>

  public var body: some View {
    HStack(alignment: .center, spacing: spacing) {
      ForEach(elements) { element in
        buildLabel(element)
          .background {
            Measure<OrderedWidthsPreferenceKey> { value, geometry in
              value[element] = geometry.size.width
            }
          }
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

  private var alignedButtonsRowOffset: CGFloat {
    let selectedIndex = widths.index(forKey: selectedElement)!
    let buttonWidths = widths.elements.values[..<selectedIndex].reduce(0, +)
    // Zero-based (effectively: spacing * items.count - 1)
    let interButtonSpacing = spacing * CGFloat(selectedIndex)
    let centerOfCurrentSelection = widths.elements[selectedIndex].value / 2
    return buttonWidths + interButtonSpacing + centerOfCurrentSelection
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
