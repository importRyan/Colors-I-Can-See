// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import TCA

public struct ImageGrid: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    @BindableState var showFileImporter: Bool

    public init(showFileImporter: Bool = false) {
      self.showFileImporter = showFileImporter
    }
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
