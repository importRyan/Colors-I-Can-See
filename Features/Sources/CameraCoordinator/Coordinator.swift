import ColorsUI
import Camera
import ComposableArchitecture
import Onboarding
import TCACoordinators

extension Root {
  public struct Coordinator: ReducerProtocol {

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
      return Reduce<State, Action> { state, action in
        switch action {

        case let .routeAction(_, action: .onboarding(.advanceToCamera(vision))):
          state.routes.presentCover(
            .camera(
              .init(vision: vision)
            )
          )
          return .none

        default:
          break
        }
        return .none
      }.forEachRoute {
        Route()
      }
      ._printChanges()
    }

    public enum Action: IndexedRouterAction {
      case routeAction(Int, action: Route.Action)
      case updateRoutes(Routes)
    }

    public struct State: Equatable, IndexedRouterState {
      public var routes: Routes

      static let initialState = Self(
        routes: [
          .root(.camera(.init(vision: .typical)), embedInNavigationView: true),
          .sheet(.onboarding(.init()))
        ]
      )
    }
  }
}

// MARK: - View Glue

extension Root.Store {
  public static let initialState = StoreOf<Root.Coordinator>(
    initialState: .initialState,
    reducer: Root.Coordinator()
  )
}

extension Root.Coordinator {

  public struct Route: ReducerProtocol {

    public var body: some ReducerProtocol<State, Action> {
      Scope(state: /State.onboarding, action: /Action.onboarding) {
        Onboarding()
      }
      Scope(state: /State.camera, action: /Action.camera) {
        Camera()
      }
    }

    public enum Action: Equatable {
      case onboarding(Onboarding.Action)
      case camera(Camera.Action)
    }

    public enum State: Equatable, Hashable, Identifiable {
      public var id: Self { self }
      case onboarding(Onboarding.State)
      case camera(Camera.State)
    }
  }

  public typealias Routes = [TCACoordinators.Route<Route.State>]
}

public struct Root: View {

  private let store: Store

  public typealias Store = StoreOf<Root.Coordinator>

  public init(store: Store) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store) { scopedStore in
      SwitchStore(scopedStore) {
        CaseLet(
          state: /Root.Coordinator.Route.State.onboarding,
          action: Root.Coordinator.Route.Action.onboarding,
          then: Onboarding.Screen.init
        )
        CaseLet(
          state: /Root.Coordinator.Route.State.camera,
          action: Root.Coordinator.Route.Action.camera,
          then: Camera.Screen.init
        )
      }
    }
  }
}

public struct RootCoordinator: ReducerProtocol {

  public var body: some ReducerProtocol<State, Action> {
    return Reduce<State, Action> { state, action in
      switch action {

      case let .routeAction(_, action: .onboarding(.advanceToCamera(vision))):
        state.routes.push(.camera(
          .init(vision: vision)
        ))
        return .none

      default:
        break
      }
      return .none
    }
    .forEachRoute { Route() }
  }

  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: Route.Action)
    case updateRoutes(Routes)
    case didFinishLaunching
  }

  public struct State: Equatable, IndexedRouterState {
    public var routes: Routes

    public static let initialState = RootCoordinator.State(
      routes: [.root(
        .onboarding(.init()),
        embedInNavigationView: true
      )]
    )
  }
}

// MARK: - Public Module Interface

public typealias RootStore = StoreOf<RootCoordinator>

extension RootStore {
  public static let initialState = RootStore.init(
    initialState: .initialState,
    reducer: RootCoordinator()
  )
}

// MARK: - Route Glue

extension RootCoordinator {

  public struct Route: ReducerProtocol {

    public var body: some ReducerProtocol<State, Action> {
      Scope(state: /State.onboarding, action: /Action.onboarding) {
        Onboarding()
      }
      Scope(state: /State.camera, action: /Action.camera) {
        Camera()
      }
    }

    public enum Action: Equatable {
      case onboarding(Onboarding.Action)
      case camera(Camera.Action)
    }

    public enum State: Equatable, Hashable, Identifiable {
      public var id: Self { self }
      case onboarding(Onboarding.State)
      case camera(Camera.State)
    }
  }

  public struct Router: View {

    public init(store: StoreOf<RootCoordinator>) {
      self.store = store
    }

    private let store: StoreOf<RootCoordinator>

    public var body: some View {
      TCARouter(store) { scopedStore in
        SwitchStore(scopedStore) {
          CaseLet(
            state: /Route.State.onboarding,
            action: Route.Action.onboarding,
            then: Onboarding.Screen.init
          )
          CaseLet(
            state: /Route.State.camera,
            action: Route.Action.camera,
            then: { store in
              Camera.Screen(store: store)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .interactiveDismissDisabled(true)
            }
          )
        }
      }
    }
  }

  public typealias Routes = [TCACoordinators.Route<Route.State>]
}
