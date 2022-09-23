// Copyright 2022 by Ryan Ferrell. @importRyan

import CameraClient
import ColorsUI
import ComposableArchitecture

extension Camera {

  public struct Screen: View {

    public init() {
      self.store = .init(initialState: .init(), reducer: Camera.init())
    }

    private let store: StoreOf<Camera>

    public var body: some View {
      WithViewStore(store) { viewStore in
        ZStack(alignment: .topLeading) {
          CameraFeed()
          CameraControlsView(
            simulation: viewStore.binding(\.$vision)
          )
          .animation(.easeOut, value: viewStore.vision)
        }
      }
    }
  }
}

#if DEBUG
struct CameraScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Camera.Screen()
    }
  }
}
#endif
