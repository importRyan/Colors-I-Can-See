// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation

extension TaskPriority {
  /// .userInitiated
  public static let defaultEffectTaskPriority: TaskPriority = .userInitiated
}

extension EffectTask {

  /// Semantic convenience to dispatch a new action into a store
  ///
  public static func send(
    _ action: Output,
    priority: TaskPriority = .defaultEffectTaskPriority
  ) -> EffectTask<Output> {
    EffectTask.task(priority: priority) { action }
  }

  /// Immediately evaluates a condition to dispatch a new action into a store
  ///
  public static func `if`(
    _ condition: Bool,
    then trueAction: Output,
    thenPriority: TaskPriority = .defaultEffectTaskPriority,
    else falseAction: Output? = nil,
    elsePriority: TaskPriority = .defaultEffectTaskPriority
  ) -> EffectTask<Output> {
    if condition {
      return .send(trueAction, priority: thenPriority)
    } else if let falseAction {
      return .send(falseAction, priority: elsePriority)
    } else {
      return .none
    }
  }

  /// Immediately unwraps a value to dispatch a new action into a store
  ///
  public static func ifLet<V>(
    _ value: V?,
    then someAction: (V) -> Output,
    thenPriority: TaskPriority = .defaultEffectTaskPriority,
    else noneAction: Output? = nil,
    elsePriority: TaskPriority = .defaultEffectTaskPriority
  ) -> EffectTask<Output> {
    if let value {
      return .send(someAction(value), priority: thenPriority)
    } else if let noneAction {
      return .send(noneAction, priority: elsePriority)
    } else {
      return .none
    }
  }
}
