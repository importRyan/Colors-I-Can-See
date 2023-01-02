// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI
import VisionType

struct CarouselComparisonView: View {

  let renders: [VisionType: PlatformImage]
  @Binding var vision: VisionType

  var body: some View {
    TabView(selection: $vision) {
      ForEach(VisionType.allCases) { vision in
        if let image = renders[vision]?.image {
          image
            .resizable()
            .scaledToFit()
            .tag(vision)
        }
      }
    }
#if os(iOS)
    .tabViewStyle(.page)
#endif
  }
}
