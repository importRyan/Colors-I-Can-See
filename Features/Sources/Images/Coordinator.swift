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
    public var comparison: ImageComparison.State

    public init(
      focusedImage: Int? = nil,
      comparison: ImageComparison.State = .init(renders: [:]),
      grid: ImageGrid.State = .init()
    ) {
      self.focusedImage = focusedImage
      self.comparison = comparison
      self.grid = grid
    }
  }

  public enum Action: Equatable, BindableAction {
    case grid(ImageGrid.Action)
    case comparison(ImageComparison.Action)
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
      case let .grid(.forParent(.didImportNew(render))):
        return .none

      case .comparison:
        return .none
      case .grid:
        return .none
      case .binding:
        return .none
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
    Scope(
      state: \.comparison,
      action: /Action.comparison,
      ImageComparison.init
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
//        ImageComparison.Screen(
//          store: store.scope(state: \.comparison, action: Action.comparison)
//        )
      }
      .navigationDestination(for: ImageGrid.State.self) { _ in
        #warning("Implement non TCAC iOS 16 coordinator")
        ImageGrid.Screen(
          store: store.scope(state: \.grid, action: Action.grid)
        )
      }
    }
  }
}
