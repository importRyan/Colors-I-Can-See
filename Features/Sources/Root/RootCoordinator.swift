import ColorsUI
import Camera
import ComposableArchitecture
import Models
import Onboarding

public struct Root: ReducerProtocol {

  public init() {}

  public enum State: Equatable, Hashable {
    case camera(Camera.State)
    case initialization
    case onboarding(Onboarding.State)
  }

  public enum Action: Equatable {
    case camera(Camera.Action)
    case initialization(Initialization.Action)
    case onboarding(Onboarding.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    screens
    coordinator
  }

  @ReducerBuilder<State, Action>
  private var coordinator: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {

      case .initialization(.complete):
        state = .onboarding(.init())
        return .none

      case let .onboarding(.advanceToCamera(vision)):
        state = .camera(.init(vision: vision))
        return .none

      case .camera, .initialization, .onboarding:
        return .none
      }
    }
  }

  // MARK: - Glue

  @ReducerBuilder<State, Action>
  private var screens: some ReducerProtocol<State, Action> {
    Scope(
      state: /State.camera,
      action: /Action.camera,
      Camera.init
    )
    Scope(
      state: /State.initialization,
      action: /Action.initialization,
      Initialization.init
    )
    Scope(
      state: /State.onboarding,
      action: /Action.onboarding,
      Onboarding.init
    )
  }

  public struct Screen: View {

    public init(store: StoreOf<Root>) {
      self.store = store
    }

    private let store: StoreOf<Root>

    public var body: some View {
      SwitchStore(store) {
        CaseLet(
          state: /State.camera,
          action: Action.camera,
          then: Camera.Screen.init
        )
        CaseLet(
          state: /State.initialization,
          action: Action.initialization,
          then: Initialization.Screen.init
        )
        CaseLet(
          state: /State.onboarding,
          action: Action.onboarding,
          then: Onboarding.Screen.init
        )
      }
    }
  }
}
