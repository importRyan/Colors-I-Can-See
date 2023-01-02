// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import VisionSimulation
import VisionType

extension Camera {

  public struct Screen: View {

    public init(store: Store<State, Action>) {
      self.store = store
    }

    private let store: StoreOf<Camera>

    public var body: some View {
      ZStack(alignment: .bottom) {
        cameraFeed
#if os(iOS)
        WithViewStore(store) { viewStore in
          Controls_iOS(simulation: viewStore.binding(\.$vision))
        }
#endif
      }
      .onAppear { ViewStore(store.stateless).send(.onAppear) }
      .onDisappear() { ViewStore(store.stateless).send(.onDisappear) }
      .navigationTitle(.init("Camera.NavTitle", bundle: .module))
#if os(macOS)
      .toolbar { Controls_macOSToolbar(store: store) }
      .toolbar(.visible, for: .windowToolbar)
#endif
    }

    var cameraFeed: some View {
      WithViewStore(store.actionless.scope(state: \.status)) { viewStore in
        ZStack {
          switch viewStore.state {
          case .needsSetup: EmptyView()
          case .permissionsNotGranted: Text("Camera.InstructionsToRescuePermissionsDenied", bundle: .module)
          case .settingUp: ProgressView()
          case .streaming, .resuming, .paused: CameraFeed()
          }
        }
        .animation(.easeIn, value: viewStore.state)
      }
    }
  }
}

#if DEBUG
struct CameraScreen_Previews: PreviewProvider {
  static var previews: some View {
    Camera.Screen(
      store: .init(
        initialState: .init(vision: .deutan),
        reducer: Camera()
      )
    )
  }
}
#endif
