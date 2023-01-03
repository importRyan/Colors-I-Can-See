// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
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
    public var render: ImageRender

    public init(
      primaryVision: VisionType = .deutan,
      secondaryVision: VisionType = .typical,
      comparison: ComparisonStyle = .carousel,
      comparisonOptions: [ComparisonStyle] = ComparisonStyle.allCases,
      render: ImageRender
    ) {
      self.primaryVision = primaryVision
      self.secondaryVision = secondaryVision
      self.comparison = comparison
      self.comparisonOptions = comparisonOptions
      self.render = render
    }
  }

  public enum Action: Equatable, BindableAction {
    case onAppear
    case pressedImportImage
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case .pressedImportImage:
        return .none
      case .binding:
        return .none
      }
    }
  }
}
