import ColorsUI
import Camera
import ComposableArchitecture
import Onboarding

public class RootStore {
  public init() {
  }

  let store = StoreOf<Onboarding>(initialState: .init(), reducer: Onboarding())
}

public struct RootView: View {
  public init(
    store: RootStore
  ) {
    self.store = store.store
  }

  let store: StoreOf<Onboarding>

  public var body: some View {
    NavigationView {
      Onboarding.Screen(store: store)
        .coordinateSpace(name: CoordinateSpace.rootScreen)
    }
  }
}

#if DEBUG
public struct Root_Previews: PreviewProvider {
  public static var previews: some View {
    RootView(store: RootStore())
  }
}
#endif


