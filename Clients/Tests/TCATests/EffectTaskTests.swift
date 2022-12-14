// Copyright 2022 by Ryan Ferrell. @importRyan

import XCTest

@testable import TCA

@MainActor
final class EffectTaskTests: XCTestCase {

  // MARK: - If

  func testIf_True_SpecifiedActions() async {
    let store = testStoreForAction {
      .if(true, then: .result(.affirmative), else: .result(.negative))
    }
    await store.send(.invokeTestAction)
    await store.receive(.result(.affirmative))
  }

  func testIf_True_NoElseAction() async {
    let store = testStoreForAction {
      .if(true, then: .result(.affirmative))
    }
    await store.send(.invokeTestAction)
    await store.receive(.result(.affirmative))
  }

  func testIf_False_SpecifiedActions() async {
    let store = testStoreForAction {
      .if(false, then: .result(.affirmative), else: .result(.negative))
    }
    await store.send(.invokeTestAction)
    await store.receive(.result(.negative))
  }

  func testIf_False_NoElseAction() async {
    let store = testStoreForAction {
      .if(false, then: .result(.affirmative))
    }
    await store.send(.invokeTestAction)
  }

  // MARK: - If Let

  func testIfLet_Some_SpecifiedAction() async {
    let store = testStoreForAction {
      .ifLet(1, then: { .result(.unwrapped($0)) }, else: .result(.negative))
    }
    await store.send(.invokeTestAction)
    await store.receive(.result(.unwrapped(1)))
  }

  func testIfLet_Some_NoElseAction() async {
    let store = testStoreForAction {
      .ifLet(1, then: { .result(.unwrapped($0)) })
    }
    await store.send(.invokeTestAction)
    await store.receive(.result(.unwrapped(1)))
  }

  func testIfLet_Nil_SpecifiedActions() async {
    let store = testStoreForAction {
      .ifLet(Int?.none, then: { .result(.unwrapped($0)) }, else: .result(.negative))
    }
    await store.send(.invokeTestAction)
    await store.receive(.result(.negative))
  }

  func testIfLet_Nil_NoElseActions() async {
    let store = testStoreForAction {
      .ifLet(Int?.none, then: { .result(.unwrapped($0)) })
    }
    await store.send(.invokeTestAction)
  }
}

fileprivate let testStoreForAction: (
  @escaping () -> EffectTask<TestReducer.Action>
) -> TestStore<
  TestReducer.State, TestReducer.Action, TestReducer.State, TestReducer.Action, ()
> = { action in
  TestStore(
    initialState: .init(),
    reducer: TestReducer(testAction: action)
  )
}

fileprivate struct TestReducer: ReducerProtocol {

  let testAction: () -> EffectTask<Action>

  struct State: Equatable {
    init() { }
  }

  enum Action: Equatable {
    case invokeTestAction
    case result(ActionResult)
  }

  enum ActionResult: Equatable {
    case affirmative
    case unwrapped(Int)
    case negative
  }

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .invokeTestAction:
        return testAction()
      case .result:
        return .none
      }
    }
  }
}
