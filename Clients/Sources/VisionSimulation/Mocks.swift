// Copyright 2022 by Ryan Ferrell. @importRyan

#if DEBUG
import ColorVision
import XCTestDynamicOverlay

extension VisionSimulationClient {
  public static let failing = VisionSimulationClient.init(
    initialize: unimplemented("\(Self.self).initialize"),
    changeSimulation: unimplemented("\(Self.self).changeSimulation")
  )


  public static let mockFailure = Self.init(
    initialize: { _ in
      throw InitializationError.gpuUnavailable
    },
    changeSimulation: { _ in
    }
  )

  public static let mockSuccess = {
    return Self.init(
      initialize: { _ in
          .init()
      },
      changeSimulation: { _ in
      }
    )
  }()
}
#endif
