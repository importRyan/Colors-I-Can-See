// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct IfItFits<Content: View>: View {
  public init(
    in axis: Axis.Set,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.axis = axis
    self.content = content
  }

  private let axis: Axis.Set

  @ViewBuilder
  private let content: () -> Content

  public var body: some View {
    ViewThatFits(in: axis) {
      content()
      Color.clear
        .frame(width: 0, height: 0)
        .hidden()
    }
  }
}
