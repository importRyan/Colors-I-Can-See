// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA

extension ImageGrid {

  public struct Screen: View {

    public init(store: StoreOf<ImageGrid>) {
      self.store = store
    }

    private let store: StoreOf<ImageGrid>

    public var body: some View {
      WithViewStore(store) { viewStore in
        ScrollView {
          EmptyGridPrompt(
            pressedImportImage: {
              ViewStore(store.stateless).send(.pressedImportImage)
            }
          )
        }
        .navigationTitle("Images")
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            if case .workingOn = viewStore.render {
              ProgressView()
                .controlSize(.small)
            } else {
              CButton(
                action: { viewStore.send(.pressedImportImage) },
                label: "+"
              )
            }
          }
        }
        .fileImporter(
          isPresented: viewStore.binding(\.$showFileImporter),
          allowedContentTypes: [.image],
          onCompletion: { completion in
            if case let .success(url) = completion {
              viewStore.send(.importImageAt(url))
            }
          }
        )
      }
      .onAppear { ViewStore(store.stateless).send(.onAppear) }
    }
  }
}

struct EmptyGridPrompt: View {

  let pressedImportImage: () -> Void

  var body: some View {
    CButton(action: pressedImportImage, label: "Import")
  }
}
