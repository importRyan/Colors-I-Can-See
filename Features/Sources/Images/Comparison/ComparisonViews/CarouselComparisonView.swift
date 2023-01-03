// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI
import VisionType

struct CarouselComparisonView: View {

  let renders: [VisionType: PlatformImage]
  @Binding var vision: VisionType

  var body: some View {
    TabView(selection: $vision) {
      ForEach(VisionType.allCases) { vision in
        if let render = renders[vision] {
          render.image
            .resizable()
            .scaledToFill()
            .tag(vision)
            .tabItem { Text(vision.localizedInfo.shortName) }
        }
      }
    }
#if os(iOS)
    .tabViewStyle(.page(indexDisplayMode: .always))
#endif
  }
}
