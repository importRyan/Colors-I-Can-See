// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import ColorVision

struct SwipeMenu: View {

  @Binding var simulation: VisionType

  @GestureState
  var translation = 0.0

  static let neutralChange = 5.0

  var gesturedSimulation: VisionType {
    switch translation {
    case ...(-Self.neutralChange):
      return simulation.nextMoreCommonVision()
    case Self.neutralChange...:
      return simulation.nextLessCommonVision()
    default:
      return simulation
    }
  }

  var body: some View {
    ScrollViewReader { scroller in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15) {
          ForEach(VisionType.allCases) { vision in
            visionButton(vision)
          }
        }
        .padding(.horizontal)
      }
      .onChange(of: simulation) { newValue in
        withAnimation {
          scroller.scrollTo(newValue, anchor: SwiftUI.UnitPoint.leading)
        }
      }
      .onChange(of: gesturedSimulation) { newValue in
        withAnimation {
          scroller.scrollTo(newValue, anchor: SwiftUI.UnitPoint.leading)
        }
      }
      .allowsHitTesting(false)
    }
    .contentShape(Rectangle())
    .highPriorityGesture(
      swipeGesture()
    )
    .frame(maxHeight: 50)
  }

  private func visionButton(_ vision: VisionType) -> some View {
    Text(vision.localizedInfo.shortName)
      .fontWeight(gesturedSimulation == vision ? .semibold : .medium)
      .textCase(.uppercase)
      .id(vision)
      .tag(vision)
      .foregroundColor(gesturedSimulation == vision ? vision.primaryColor : .primary)
  }

  private func swipeGesture() -> _EndedGesture<GestureStateGesture<DragGesture, Double>> {
    DragGesture()
      .updating($translation) { value, state, _ in
        state = value.translation.width
      }
      .onEnded { value in
        switch value.translation.width {
        case ...(-Self.neutralChange):
          simulation = simulation.nextMoreCommonVision()
        case Self.neutralChange...:
          simulation = simulation.nextLessCommonVision()
        default:
          return
        }
      }
  }
}

// MARK: - Other


extension VerticalAlignment {
  struct MenuAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[VerticalAlignment.center]
    }
  }
  static let menuAlignment = VerticalAlignment(MenuAlignment.self)
}

struct DemoAlignmentSwipeMenu: View {

  @State var selectedOption = 2
  @State var offsets = [AnyHashable:CGFloat]()

  var body: some View {
    HStack {
      ForEach(1..<6) {
        button($0)
      }
    }
    .coordinateSpace(name: "Menu")
    .offset(x: offsets[selectedOption] ?? 0)
    .onPreferenceChange(DictionaryKey.self) { offsets = $0 }
    .animation(.easeIn, value: selectedOption)
    .animation(.easeIn, value: offsets)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  func button(_ number: Int) -> some View {
    Button("\(number)") { selectedOption = number }
      .foregroundColor(selectedOption == number ? .pink : .primary)
      .background {
        Measure<DictionaryKey> { value, geometry in
          value[number] = geometry.frame(in: .named("Menu")).midX
        }
      }
  }

  func alignSelectedOption(_ viewDimensions: ViewDimensions) -> CGFloat {
    viewDimensions[VerticalAlignment.center] + (offsets[selectedOption] ?? 0)
  }
}

struct DictionaryKey: PreferenceKey {
  static var defaultValue: [AnyHashable: CGFloat] = [:]

  static func reduce(value: inout [AnyHashable: CGFloat], nextValue: () -> [AnyHashable: CGFloat]) {
    value.merge(nextValue(), uniquingKeysWith: { $1 })
  }
}

