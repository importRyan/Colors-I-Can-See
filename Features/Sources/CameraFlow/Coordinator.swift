import ColorsUI
import Camera
import ComposableArchitecture
import TCACoordinators

extension CameraFlow {
  public struct Coordinator: ReducerProtocol {

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
      return Reduce<State, Action> { state, action in
        switch action {

        default:
          break
        }
        return .none
      }
      .forEachRoute {
        Scope(state: /RouteState.camera, action: /RouteAction.camera) {
          Camera()
        }
      }
    }

    public enum Action: Equatable, IndexedRouterAction {
      case routeAction(Int, action: RouteAction)
      case updateRoutes([Route<RouteState>])
    }

    public struct State: Equatable, Hashable, IndexedRouterState {
      public var routes: [Route<RouteState>]

      public static func initialState(settings: Camera.State) -> Self {
        .init(
          routes: [
            .root(.camera(settings), embedInNavigationView: true)
          ]
        )
      }
    }
  }
}

// MARK: - Routing Glue

public struct CameraFlow: View {

  private let store: StoreOf<CameraFlow.Coordinator>

  public init(store: StoreOf<CameraFlow.Coordinator>) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store) { scopedStore in
      SwitchStore(scopedStore) {
        CaseLet(
          state: /RouteState.camera,
          action: RouteAction.camera,
          then: Camera.Screen.init
        )
      }
    }
  }

  public enum RouteAction: Equatable {
    case camera(Camera.Action)
  }

  public enum RouteState: Equatable, Hashable, Identifiable {
    public var id: Self { self }
    case camera(Camera.State)
  }
}

extension Route: Hashable where Screen: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.screen.hashValue)
  }
}
