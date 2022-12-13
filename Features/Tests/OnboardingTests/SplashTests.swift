// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import XCTest

@testable import Onboarding

final class SplashTests: XCTestCase {

  func testOnAppear() {
    let store = TestStore(
      initialState: .init(),
      reducer: Splash()
    )
    store.send(.onAppear) {
      $0.didAppear = true
    }
  }
}
