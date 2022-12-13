// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorVision
import ComposableArchitecture
import XCTest

@testable import Onboarding

final class VisionTypesTests: XCTestCase {

  func testEditsVisionSimulationSelection() {
    let store = TestStore(
      initialState: .init(vision: .tritan),
      reducer: VisionTypes()
    )
    store.send(.binding(.set(\.$vision, .deutan))) {
      $0.vision = .deutan
    }
    store.send(.binding(.set(\.$vision, .monochromat))) {
      $0.vision = .monochromat
    }
  }

  func testAcceptsInjectedVisionSimulation() {
    let input = VisionType.tritan
    let state = VisionTypes.State(vision: input)
    XCTAssertNoDifference(input, state.vision)
  }
}
