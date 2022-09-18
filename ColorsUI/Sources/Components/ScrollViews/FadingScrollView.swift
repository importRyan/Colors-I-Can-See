// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI
import Combine

public struct FadedScrollView<Content: View>: View {

  public init(
    axes: Axis.Set = .vertical,
    showsIndicators: Bool = true,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.axes = axes
    self.content = content
    self.showsIndicators = showsIndicators
  }

  private let axes: Axis.Set
  private let content: () -> Content
  private let showsIndicators: Bool

  @StateObject
  private var fade = ScrollFadeController()

  public var body: some View {
    TrackableScrollView(
      axes: axes,
      showsIndicators: showsIndicators,
      onScroll: { fade.bottomOffset.send($0.bottomTrailing) },
      content: content
    )
    .mask(alignment: .bottom) {
      ConditionalMask(mask: fade.mask)
    }
  }
}

public struct ConditionalMask: View {
  @ObservedObject var mask: ScrollFadeController.Mask

  public var body: some View {
    VStack(spacing: 0) {
      Color.black
      dynamicFade
        .frame(height: mask.size)
        .animation(.linear(duration: 0.3), value: mask.opacity)
    }
  }

  private var dynamicFade: some View {
    ZStack {
      Color.black
        .opacity(1.0 - mask.opacity)

      LinearGradient(
        gradient: .init(colors: [
          Color.black.opacity(1),
          Color.black.opacity(0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      .opacity(mask.opacity)
    }
  }
}

public class ScrollFadeController: ObservableObject {
  public let bottomOffset = CurrentValueSubject<CGFloat, Never>(.zero)
  public let mask = Mask()

  public class Mask: ObservableObject {
    @Published var opacity = CGFloat(1)
    public let size = 75.0
    fileprivate let rampSize = 40.0
    fileprivate let rampEarlyReveal = 30.0
  }

  private lazy var opacitySub = bottomOffset
    .scan(CGFloat.greatestFiniteMagnitude) { lastValue, newValue in
      let isScrollingDown = newValue < lastValue
      let fade = isScrollingDown
      ? (newValue - self.mask.rampEarlyReveal) / self.mask.rampSize
      : newValue / self.mask.rampSize
      return max(0, min(1, fade))
    }
    .assign(to: \.mask.opacity, on: self)
}
