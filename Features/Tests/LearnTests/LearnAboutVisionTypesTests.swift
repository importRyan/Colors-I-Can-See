// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import VisionType
import XCTest

@testable import Learn

final class LearnAboutVisionTypesTests: XCTestCase {

  func testEditsVisionSimulationSelection() {
    let store = TestStore(
      initialState: .init(vision: .tritan),
      reducer: LearnAboutVisionTypes()
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
    let state = LearnAboutVisionTypes.State(vision: input)
    XCTAssertNoDifference(input, state.vision)
  }
}
