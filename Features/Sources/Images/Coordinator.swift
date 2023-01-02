// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import VisionSimulation
import VisionType

public struct ImagesCoordinator: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    @BindableState public var focusedImage: Int?
    public var grid: ImageGrid.State

    public init(focusedImage: Int? = nil, grid: ImageGrid.State = .init()) {
      self.focusedImage = focusedImage
      self.grid = grid
    }
  }

  public enum Action: Equatable, BindableAction {
    case grid(ImageGrid.Action)
    case binding(BindingAction<State>)
  }

  public var body: some ReducerProtocol<State, Action> {
    screens
    coordinator
  }

  @ReducerBuilder<State, Action>
  private var coordinator: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .grid: return .none
      case .binding: return .none
      }
    }
  }

  @ReducerBuilder<State, Action>
  private var screens: some ReducerProtocol<State, Action> {
    Scope(
      state: \.grid,
      action: /Action.grid,
      ImageGrid.init
    )
  }

}

extension ImagesCoordinator {
  public struct Screen: View {

    public init(store: StoreOf<ImagesCoordinator>) {
      self.store = store
    }

    private let store: StoreOf<ImagesCoordinator>

    public var body: some View {
      NavigationStack {
        ImageGrid.Screen(
          store: store.scope(state: \.grid, action: Action.grid)
        )
      }
    }
  }
}
