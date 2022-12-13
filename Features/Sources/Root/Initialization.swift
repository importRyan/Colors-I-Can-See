// Copyright 2022 by Ryan Ferrell. @importRyan

import Camera
import ColorsUI
import ColorVision
import Onboarding
import TCA
import VisionSimulation

public struct Initialization: ReducerProtocol {

  @Dependency(\.visionSimulation.initialize) var initializeMetal

  public enum Action: Equatable {
    case didFinishLaunching
    case setupMetal
    case setupMetalResult(TaskResult<InitializationSuccess>)
    case complete
  }

  public var body: some ReducerProtocol<Void, Action> {
    Reduce { _, action in
      switch action {
      case .didFinishLaunching:
        return .concatenate(
          Effect(value: .setupMetal)
        )

      case .setupMetal:
        let defaultStartingVision = VisionType.deutan
        return .task {
          await .setupMetalResult(
            TaskResult { try await self.initializeMetal(defaultStartingVision) }
          )
        }

      case .setupMetalResult(.success):
        return Effect(value: .complete)

      case let .setupMetalResult(.failure(error)):
        #warning("TODO: Handle error")
        print(error.localizedDescription)
        return .none

      case .complete:
        return .none
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
