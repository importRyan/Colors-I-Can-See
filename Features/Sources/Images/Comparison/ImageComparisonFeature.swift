// Copyright 2022 by Ryan Ferrell. @importRyan

import TCA
import VisionType
import SwiftUI

public struct ImageComparison: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    @BindableState public var primaryVision: VisionType
    @BindableState public var secondaryVision: VisionType
    @BindableState public var comparison: ComparisonStyle
    public var comparisonOptions: [ComparisonStyle]
    public var renders: [VisionType: PlatformImage]

    public init(
      primaryVision: VisionType = .deutan,
      secondaryVision: VisionType = .typical,
      comparison: ComparisonStyle = .carousel,
      comparisonOptions: [ComparisonStyle] = ComparisonStyle.allCases,
      renders: [VisionType: PlatformImage]
    ) {
      self.primaryVision = primaryVision
      self.secondaryVision = secondaryVision
      self.comparison = comparison
      self.comparisonOptions = comparisonOptions
      self.renders = renders
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
        return .none
      case .binding:
        return .none
      }
    }
  }
}
