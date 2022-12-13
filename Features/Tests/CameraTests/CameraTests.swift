// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import ComposableArchitecture
import XCTest

@testable import Camera

@MainActor
final class CameraTests: XCTestCase {

  func testChangeVisionSimulation() async {
    let store = TestStore(
      initialState: .init(vision: .deutan),
      reducer: Camera()
    )

    var changedSimulation: VisionType?
    store.dependencies.visionSimulation.changeSimulation = { @MainActor vision in
      changedSimulation = vision
    }

    for change in [VisionType.tritan, .monochromat] {
      await store.send(.binding(.set(\.$vision, change))) {
        $0.vision = change
      }
      XCTAssertEqual(changedSimulation, change)
    }
  }
}
