import ColorsUI
import Camera
import ComposableArchitecture
import Models
import Onboarding
import TCACoordinators

public struct Initialization: ReducerProtocol {

  public enum Action: Equatable {
    case didFinishLaunching
    case complete
  }

  public var body: some ReducerProtocol<Void, Action> {
    Reduce { _, action in
      switch action {
      case .didFinishLaunching:
        return Effect(value: .complete)
      default: return .none
      }
    }
  }

  struct Screen: View {

    let store: Store<Void, Action>

    var body: some View {
      ProgressView()
    }
  }
}
