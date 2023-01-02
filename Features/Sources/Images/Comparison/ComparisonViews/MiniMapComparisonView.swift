// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA

struct MiniMapLightTableView: View {

  var mapImage: PlatformImage
  var zoomedImage: PlatformImage

  @State private var offset = CGSize.zero

  var body: some View {
    VStack {
      Text("WIP TODO")
      Text(offset.width, format: .number)
      Text(offset.height, format: .number)

      miniMap

      VStack(spacing: 0) {
        row
        row
      }
    }
  }
}

extension MiniMapLightTableView {

  private var miniMap: some View {
    GeometryReader { geo in
      mapImage.image
        .resizable()
        .scaledToFit()
        .onContinuousHover { onMiniMapContinuousHover($0, geo) }
        .overlay { miniMapOutline }
    }
    .frame(
      width: mapImage.scaleWidth(max: 200),
      height: mapImage.scaleHeight(max: 200)
    )
    .zIndex(2)
  }

  private func onMiniMapContinuousHover(_ phase: HoverPhase, _ geo: GeometryProxy) {
    if case let .active(point) = phase {
      offset = .init(
        width: point.x / geo.size.width,
        height: point.y / geo.size.height
      )
    }
  }

  private var miniMapOutline: some View {
    Rectangle().stroke(Color.black, lineWidth: 1)
  }

  private var row: some View {
    HStack(spacing: 0) {
      image
      image
    }
  }

  private var image: some View {
    GeometryReader { geo in
      Color.clear
        .background(alignment: .topLeading) {
          zoomedImage.image
            .resizable()
            .scaledToFill()
            .offset(
              x: {
                let zoomLevel = geo.size.width / zoomedImage.size.width
                print("zoomed", zoomLevel, "viewport", geo.size.width, "image", zoomedImage.size.width)
                let raw = -geo.size.width * offset.width
                let limitedValue = -geo.size.width * min(zoomLevel, offset.width)
                print("limited", limitedValue, "raw", raw)
                return raw
              }(),
              y: -geo.size.height * min(0.8, offset.height)
            )
            .frame(width: zoomedImage.size.width, height: zoomedImage.size.height, alignment: .topLeading)
        }
    }
    .clipped()
    .border(Color.red)
  }
}
