// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import VisionType

struct CameraControls: View {

  @Binding var simulation: VisionType

  @GestureState private var translation = 0.0

  private static let neutralChange = 5.0

  private static let menuLabelTextStyle = Font.TextStyle.title3

  @ScaledMetric(
    wrappedValue: 60.0,
    relativeTo: Self.menuLabelTextStyle
  ) private var swipeTextTranslationLimit

  var body: some View {
    ZStack(alignment: .bottom) {
      swipeGestureTransparentLayer
      simulationMenu
        .padding(.bottom)
        .padding(.bottom)
        .padding(.bottom)
        .padding(.bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

extension CameraControls {

  private var simulationMenu: some View {
    ZStack {
      layoutSpacerToPreventTextTruncation
      menuLabel
        .foregroundColor(.primary)
      Menu {
        Text("Swiping also changes simulations.")
        Picker("Simulation", selection: $simulation) {
          ForEach(VisionType.allCases) { vision in
            Text(vision.localizedInfo.shortName)
              .tag(vision)
          }
        }
      } label: {
        Color.clear
      }
      .menuOrder(.fixed) // Mirrors vertical swipe gesture
      .menuIndicator(.hidden)
    }
    .animation(.default, value: simulation)
    .animation(.interactiveSpring(), value: translation)
    .fixedSize()
    .font(.system(Self.menuLabelTextStyle, weight: .medium))
    .padding()
    .padding(.vertical, -5)
    .clipped()
    .background(.ultraThinMaterial, in: Capsule())
    .preferredColorScheme(.dark)
  }

  private var layoutSpacerToPreventTextTruncation: some View {
    Text(VisionType.longestName)
      .hidden()
      .accessibilityHidden(true)
      .fixedSize(horizontal: false, vertical: true)
      .lineLimit(1)
      .padding(.horizontal)
  }

  @ViewBuilder
  private var menuLabel: some View {
    if translation > swipeTextTranslationLimit {
      Text(simulation.nextLessCommonVision().localizedInfo.shortName)
        .transition(.asymmetric(
          insertion: .push(from: .top),
          removal: .identity
        ))
    } else if translation < -swipeTextTranslationLimit {
      Text(simulation.nextMoreCommonVision().localizedInfo.shortName)
        .transition(.asymmetric(
          insertion: .push(from: .bottom),
          removal: .identity
        ))
    } else {
      CText(simulation.localizedInfo.shortName)
        .frame(maxWidth: .infinity)
        .offset(y: translation * 0.35)
        .transition(.asymmetric(
          insertion: translation == 0
          ? .identity
          : .push(from: translation < 0 ? .top : .bottom),
          removal: .identity
        ))
    }
  }

  private var swipeGestureTransparentLayer: some View {
    Color.clear
      .contentShape(Rectangle())
      .gesture(
        DragGesture()
          .updating($translation) { value, state, _ in
            let translation = value.translation.height
            if canSwipeTransition(translation) {
              state = translation
            } else {
              let limit = 10.0
              state = max(-limit, min(limit, translation))
            }
          }
          .onEnded { value in
            let translation = value.translation.height
            guard canSwipeTransition(translation) else { return }
            switch translation {
            case ...(-Self.neutralChange):
              simulation = simulation.nextMoreCommonVision()
            case Self.neutralChange...:
              simulation = simulation.nextLessCommonVision()
            default:
              return
            }
          }
      )
  }

  private func canSwipeTransition(_ translation: Double) -> Bool {
    if simulation == .leastCommon {
      return translation.sign == .minus
    } else if simulation == .mostCommon {
      return translation.sign == .plus
    } else {
      return true
    }
  }
}

extension VisionType {
  fileprivate static let longestName = VisionType
    .allCases
    .map(\.localizedInfo.shortName)
    .reduce(into: String()) { longest, name in
      if longest.count < name.count {
        longest = name
      }
    }
}
