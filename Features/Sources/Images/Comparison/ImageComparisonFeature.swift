// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import VisionType

public struct ImageComparison: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public var didAppear: Bool
    public var primaryVision: VisionType
    public var secondaryVision: VisionType
    @BindableState public var comparison: ComparisonStyle
    public var comparisonOptions: [ComparisonStyle]

    public init(
      didAppear: Bool = false,
      primaryVision: VisionType = .typical,
      secondaryVision: VisionType = .deutan,
      comparison: ComparisonStyle = .sideBySideHorizontal,
      comparisonOptions: [ComparisonStyle] = ComparisonStyle.allCases
    ) {
      self.didAppear = didAppear
      self.primaryVision = primaryVision
      self.secondaryVision = secondaryVision
      self.comparison = comparison
      self.comparisonOptions = comparisonOptions
    }
  }

  public enum Action: Equatable, BindableAction {
    case onAppear
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.didAppear = true
        return .none
      case .binding:
        return .none
      }
    }
  }
}
