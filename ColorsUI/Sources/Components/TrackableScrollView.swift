// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

extension CoordinateSpace {
   public static let rootScreen = "RootScreen"
}

public struct TrackableScrollView<T: View>: View {

  public init(
    axes: Axis.Set = .vertical,
    showsIndicators: Bool = true,
    onScroll: @escaping (ScrollOffsets) -> Void,
    @ViewBuilder content: () -> T
  ) {
    self.axes = axes
    self.content = content()
    self.onScroll = onScroll
    self.showsIndicators = showsIndicators
  }

  private let axes: Axis.Set
  private let content: T
  private let onScroll: (ScrollOffsets) -> Void
  private let showsIndicators: Bool

  public var body: some View {
    GeometryReader { outerProxy in
      ScrollView(axes, showsIndicators: showsIndicators) {
        content
          .background(alignment: .topLeading) {
            Measure<ScrollOffsetsKey>(
              transform: measureTopLeading
            )
          }
          .background(alignment: .bottomTrailing) {
            Measure<ScrollOffsetsKey>(
              transform: measureBottomTrailing
            )
          }
      }
      .background {
        Measure<ScrollOffsetsKey>(
          transform: measureScrollView
        )
      }
    }
    .onPreferenceChange(ScrollOffsetsKey.self, perform: onScroll)
  }

  private func measureTopLeading(value: inout ScrollOffsetsKey.Value, proxy: GeometryProxy) {
    value.topLeading = proxy.frame(in: .global).origin.y
  }

  private func measureBottomTrailing(value: inout ScrollOffsetsKey.Value, proxy: GeometryProxy) {
    value._bottomTrailingRaw = proxy.frame(in: .global).origin.y
  }

  private func measureScrollView(value: inout ScrollOffsetsKey.Value, proxy: GeometryProxy) {
    value.scrollViewHeight = proxy.size.height
    value.scrollViewMinY = proxy.frame(in: .global).minY
  }
}

struct Measure<Key: PreferenceKey>: View {

  let transform: (_ value: inout Key.Value, _ proxy: GeometryProxy) -> Void

  var body: some View {
    GeometryReader { proxy in
      Color.clear
        .transformPreference(Key.self) { transform(&$0, proxy) }
    }
    .frame(width: 0, height: 0)
  }
}

public struct ScrollOffsetsKey: PreferenceKey {
  public static var defaultValue: ScrollOffsets = .init()
  public static func reduce(value: inout ScrollOffsets, nextValue: () -> ScrollOffsets) {

  }
}

public struct ScrollOffsets: Equatable {
  /// Offset of start of ScrollView to Safe Area
  public var topLeading = CGFloat.zero
  /// Offset of bottom of content to visible ScrollView frame
  public var bottomTrailing: CGFloat {
    _bottomTrailingRaw - scrollViewHeight - scrollViewMinY
  }

  /// ScrollView frame height
  public var scrollViewHeight = CGFloat.zero
  /// ScrollView offset to Safe Area
  public var scrollViewMinY = CGFloat.zero
  /// Locally measured offset of bottom of ScrollView content
  var _bottomTrailingRaw = CGFloat.zero
}
