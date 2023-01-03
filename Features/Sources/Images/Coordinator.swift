// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import TCA
import VisionSimulation
import VisionType
import SwiftUINavigation

public struct ImagesCoordinator: ReducerProtocol {

  public init() {}

  public struct State: Equatable, Hashable {
    @BindableState public var destination: Destination?
    public var grid: ImageGrid.State

    public init(
      destination: Destination? = .none,
      grid: ImageGrid.State = .init()
    ) {
      self.destination = destination
      self.grid = grid
    }
  }

  public enum Action: Equatable, BindableAction {
    case grid(ImageGrid.Action)
    case comparison(ImageComparison.Action)
    case binding(BindingAction<State>)
  }

  public enum Destination: Equatable, Hashable {
    case comparison(ImageComparison.State)
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
        state.destination = .comparison(.init(render: render))
        return .none
      case .comparison(.pressedImportImage):
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
    Scope(state: \.destination, action: /.self) {
      EmptyReducer()
        .ifCaseLet(/Destination.comparison, action: /Action.comparison) {
          ImageComparison()
        }
    }
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
        WithViewStore(
          store
        ) { viewStore in
          ImageGrid.Screen(
            store: store.scope(state: \.grid, action: Action.grid)
          )
          .navigationDestination(
            unwrapping: viewStore.binding(\.$destination),
            case: /Destination.comparison,
            destination: comparisonDestination
          )
        }
      }
    }

    func comparisonDestination(_ unused: Binding<ImageComparison.State>) -> some View {
      IfLetStore(store.scope(state: \.destination)) { destinationStore in
        SwitchStore(destinationStore) {
          CaseLet(
            state: /Destination.comparison,
            action: Action.comparison,
            then: ImageComparison.Screen.init
          )
        }
      }
    }
  }
}
