// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation

extension EffectTask {

  /// Semantic convenience to dispatch a new action into a store
  ///
  public static func send(_ action: Output) -> EffectTask<Output> {
    EffectTask.task { action }
  }

  /// Immediately evaluates a condition to dispatch a new action into a store
  ///
  public static func `if`(
    _ condition: Bool,
    then trueAction: Output,
    else falseAction: Output? = nil
  ) -> EffectTask<Output> {
    if condition {
      return .send(trueAction)
    } else if let falseAction {
      return .send(falseAction)
    } else {
      return .none
    }
  }

  /// Immediately unwraps a value to dispatch a new action into a store
  ///
  public static func ifLet<V>(
    _ value: V?,
    then someAction: (V) -> Output,
    else noneAction: Output? = nil
  ) -> EffectTask<Output> {
    if let value {
      return .send(someAction(value))
    } else if let noneAction {
      return .send(noneAction)
    } else {
      return .none
    }
  }
}
