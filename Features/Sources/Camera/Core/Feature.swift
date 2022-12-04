// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture
import Models

public struct Camera: ReducerProtocol {

  public init() {
    
  }

  public struct State: Equatable, Hashable, Identifiable {
    public init(vision: VisionType) {
      self.vision = vision
    }

    @BindableState
    public var vision: VisionType
    public var id: Self { self }
  }

  public enum Action: BindableAction, Equatable {
    case pressedCapturePhoto
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .pressedCapturePhoto:
        return .none
      case .binding:
        return .none
      }
    }
  }
}
