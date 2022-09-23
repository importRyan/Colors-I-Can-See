// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

extension View {
  public func fadeEdges(
    _ axis: Axis.Set,
    fadeInset: Double = 0.05,
    fadeWidth: Double = 0.2
  ) -> some View {
    modifier(
      FadeEdgesMask(axis: axis, fadeInset: fadeInset, fadeWidth: fadeWidth)
    )
  }
}

public struct FadeEdgesMask: ViewModifier {

  public init(axis: Axis.Set, fadeInset: Double = 0.05, fadeWidth: Double = 0.2) {
    self.axis = axis
    self.fadeInset = fadeInset
    self.fadeWidth = fadeWidth
  }
  private let axis: Axis.Set
  private let fadeInset: Double
  private let fadeWidth: Double

  public func body(content: Content) -> some View {
    content.mask(
      LinearGradient(
        stops: [
          .init(color: .black.opacity(0), location: fadeInset),
          .init(color: .black.opacity(1), location: fadeInset + fadeWidth),
          .init(color: .black.opacity(1), location: 1 - fadeInset - fadeWidth),
          .init(color: .black.opacity(0), location: 1 - fadeInset)
        ],
        startPoint: axis == .horizontal ? .leading : .top,
        endPoint: axis == .horizontal ? .trailing : .bottom
      )
    )
  }
}
