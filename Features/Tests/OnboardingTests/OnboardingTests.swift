import ComposableArchitecture
import Models
import XCTest

@testable import Onboarding

final class OnboardingTests: XCTestCase {

  func testAcceptsInjectedVisionSimulation() {
    let input = VisionType.tritan
    let state = VisionTypes.State(vision: input)
    XCTAssertNoDifference(input, state.vision)
  }

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
}
