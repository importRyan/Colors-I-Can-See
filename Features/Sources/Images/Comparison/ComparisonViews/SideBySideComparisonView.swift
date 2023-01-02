// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI

struct SideBySideComparisonView: View {
  let images: (left: PlatformImage, right: PlatformImage)
  let axis: Axis

  var body: some View {
    switch axis {
    case .vertical: vertical
    case .horizontal: horizontal
    }
  }

  private var vertical: some View {
#if os(macOS)
    VerticalMacOSView(images: images)
#elseif os(iOS)
    images.right.image
#endif
  }

  private var horizontal: some View {
#if os(macOS)
    HorizontalMacOSView(images: images)
#elseif os(iOS)
    images.right.image
#endif
  }
}

extension SideBySideComparisonView {

#if os(macOS)
  struct HorizontalMacOSView: View {

    let images: (left: PlatformImage, right: PlatformImage)

    var body: some View {
      GeometryReader { geo in
        HSplitView {
          buildImage(images.left, in: geo.size)

          GeometryReader { innerGeo in
            buildImage(
              images.right,
              in: geo.size,
              xOffset: -innerGeo.frame(in: .named("Horizontal")).minX
            )
          }
        }
      }
      .coordinateSpace(name: "Horizontal")
      .aspectRatio(images.left.aspectRatio, contentMode: .fit)
    }
  }

  struct VerticalMacOSView: View {

    let images: (left: PlatformImage, right: PlatformImage)

    var body: some View {
      GeometryReader { geo in
        VSplitView {
          buildImage(images.left, in: geo.size)

          GeometryReader { innerGeo in
            buildImage(
              images.right,
              in: geo.size,
              yOffset: -(geo.size.height - innerGeo.size.height)
            )
          }
        }
      }
      .coordinateSpace(name: "Vertical")
      .aspectRatio(images.left.aspectRatio, contentMode: .fit)
    }
  }
#endif
}

fileprivate func buildImage(
  _ platform: PlatformImage,
  in size: CGSize,
  xOffset: CGFloat = 0,
  yOffset: CGFloat = 0
) -> some View {
  Color.clear
    .background(alignment: .topLeading) {
      platform.image
        .resizable()
        .scaledToFit()
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .offset(x: xOffset, y: yOffset)
    }
}
