// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import VisionSimulation

extension Camera {

  public struct Screen: View {

    public init(store: Store<State, Action>) {
      self.store = store
    }

    private let store: StoreOf<Camera>

    public var body: some View {
      WithViewStore(store) { viewStore in
        ZStack(alignment: .topLeading) {
          CameraFeed()
          CameraControlsView(
            simulation: viewStore.binding(\.$vision)
          )
        }
      }
    }
  }
}

#if DEBUG
struct CameraScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Camera.Screen(
        store: .init(
          initialState: .init(vision: .deutan),
          reducer: Camera()
        )
      )
    }
  }
}
#endif
