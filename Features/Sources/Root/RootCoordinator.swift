import ColorsUI
import Camera
import ComposableArchitecture
import Onboarding
import TCACoordinators

struct SomeCoordinator: ReducerProtocol {

  public struct State: Equatable, IdentifiedRouterState {
    public var routes: IdentifiedArrayOf<Route<Screen.State>>

    public static let initialState = Self.init(
      routes: [
        .root(
          .onboarding(.init()), embedInNavigationView: true
        )
      ]
    )
  }

  enum Action: IdentifiedRouterAction {
    case routeAction(Screen.State.ID, action: Screen.Action)
    case updateRoutes(IdentifiedArrayOf<Route<Screen.State>>)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case let .routeAction(_, action: .onboarding(.advanceToCamera(vision))):
        state.routes.push(.camera(.init(vision: vision)))
        return .none
      default:
        return .none
      }
    }
    .forEachRoute { Screen() }
  }

  struct Screen: ReducerProtocol {

    enum State: Equatable, Hashable, Identifiable {
      var id: Self { self }
      case onboarding(Onboarding.State)
      case camera(Camera.State)
    }

    enum Action: Equatable {
      case onboarding(Onboarding.Action)
      case camera(Camera.Action)
    }

    var body: some ReducerProtocol<State, Action> {
      Scope(state: /State.onboarding, action: /Action.onboarding) {
        Onboarding()
      }
      Scope(state: /State.camera, action: /Action.camera) {
        Camera()
      }
    }

    struct Builder: View {
      private let store: StoreOf<SomeCoordinator>

      public var body: some View {
        TCARouter(store) { scopedStore in
          SwitchStore(scopedStore) {
            CaseLet(
              state: /Screen.State.onboarding,
              action: Screen.Action.onboarding,
              then: Onboarding.Screen.init
            )
            CaseLet(
              state: /Screen.State.camera,
              action: Screen.Action.camera,
              then: Camera.Screen.init
            )
          }
        }
      }
    }
  }
}
