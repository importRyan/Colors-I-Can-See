// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import TCA

public struct ImageGrid: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    public var didAppear = false
    @BindableState var showFileImporter = false
    public init() {}
  }

  public enum Action: Equatable, BindableAction {
    case onAppear
    case pressedImportImage
    case importImageAt(URL)
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.didAppear = true
        return .none
      case .pressedImportImage:
        state.showFileImporter = true
        return .none
      case let .importImageAt(url):
        state.showFileImporter = false
        return .none
      case .binding:
        return .none
      }
    }
  }
}
