// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import TCACoordinators
import VisionType

extension OnboardingFlow {
  public struct Coordinator: ReducerProtocol {

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
      Reduce<State, Action> { state, action in
        switch action {

        case .routeAction(_, action: .splash(.send(.next))):
          state.routes.push(.visionTypes(.init()))
          return .none

        case let .routeAction(_, action: .visionTypes(.send(
          .advanceToCamera(settings)
        ))):
          return Effect(value: .send(.advanceToCamera(settings)))

        default:
          break
        }
        return .none
      }
      .forEachRoute {
        Scope(state: /RouteState.splash, action: /RouteAction.splash) {
          Splash()
        }
        Scope(state: /RouteState.visionTypes, action: /RouteAction.visionTypes) {
          VisionTypes()
        }
      }
    }

    public enum Action: Equatable, IndexedRouterAction {
      case routeAction(Int, action: RouteAction)
      case updateRoutes([Route<RouteState>])
      case send(SendAction)
    }

    public enum SendAction: Equatable {
      case advanceToCamera(VisionType)
    }

    public struct State: Equatable, Hashable, IndexedRouterState {
      public var routes: [Route<RouteState>]

      public static func initialState() -> Self {
        .init(
          routes: [
            .root(.splash(.init()), embedInNavigationView: true)
          ]
        )
      }
    }
  }
}

// MARK: - Routing Glue

public struct OnboardingFlow: View {

  private let store: StoreOf<OnboardingFlow.Coordinator>

  public init(store: StoreOf<OnboardingFlow.Coordinator>) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store) { scopedStore in
      SwitchStore(scopedStore) {
        CaseLet(
          state: /RouteState.splash,
          action: RouteAction.splash,
          then: Splash.Screen.init
        )
        CaseLet(
          state: /RouteState.visionTypes,
          action: RouteAction.visionTypes,
          then: {
            VisionTypes.Screen(store: $0)
              .toolbar(.hidden, for: .automatic)
          }
        )
      }
    }
  }

  public enum RouteAction: Equatable {
    case splash(Splash.Action)
    case visionTypes(VisionTypes.Action)
  }

  public enum RouteState: Equatable, Hashable, Identifiable {
    public var id: Self { self }
    case splash(Splash.State)
    case visionTypes(VisionTypes.State)
  }
}

extension Route: Hashable where Screen: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.screen.hashValue)
  }
}
