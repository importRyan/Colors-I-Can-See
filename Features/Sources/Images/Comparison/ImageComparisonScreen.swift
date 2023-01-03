// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA

extension ImageComparison {

  public struct Screen: View {

    public init(store: StoreOf<ImageComparison>) {
      self.store = store
    }

    private let store: StoreOf<ImageComparison>

    public var body: some View {
      ZStack {
        WithViewStore(store) { viewStore in
          CarouselComparisonView(
            renders: viewStore.render.renders,
            vision: viewStore.binding(\.$primaryVision)
          )
//          if let primary = viewStore.render.renders[viewStore.primaryVision],
//             let secondary = viewStore.render.renders[viewStore.secondaryVision] {
//            switch viewStore.comparison {
//            case .carousel:
//              CarouselComparisonView(
//                renders: viewStore.render.renders,
//                vision: viewStore.binding(\.$primaryVision)
//              )
//            case .hoverPortal:
//              HoverPortalComparisonView(
//                baseImage: secondary,
//                maskedImage: primary,
//                portalDiameter: 150
//              )
//            case .miniMapLightTable:
//              MiniMapLightTableView(
//                mapImage: secondary,
//                zoomedImage: primary
//              )
//            case .sideBySideHorizontal:
//              SideBySideComparisonView(
//                images: (left: secondary, right: primary),
//                axis: .horizontal
//              )
//            case .sideBySideVertical:
//              SideBySideComparisonView(
//                images: (left: secondary, right: primary),
//                axis: .vertical
//              )
//            }
//          }
        }
      }
      .onAppear { ViewStore(store.stateless).send(.onAppear) }
      .navigationTitle("Comparison")
      .toolbarTitleMenu {
        Button("Implement Export Feature") { }
      }
      .toolbarRole(.editor)
#if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(.visible, for: .navigationBar)
#endif
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("+") { ViewStore(store.stateless).send(.pressedImportImage) }
        }
        ToolbarItem(placement: .secondaryAction) {
          WithViewStore(store) { viewStore in
            ComparisonPicker(comparison: viewStore.binding(\.$comparison))
          }
        }
      }
    }
  }
}
