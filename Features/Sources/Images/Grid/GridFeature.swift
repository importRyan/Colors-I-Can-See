// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Foundation
import TCA
import VisionSimulation
import VisionType

import CoreGraphics.CGImage

public struct ImageGrid: ReducerProtocol {

  @Dependency(\.visionSimulation.computeSimulations)
  var computeSimulations

  public init() {}

  public struct State: Equatable, Hashable {
    @BindableState public var showFileImporter: Bool
    public var render: RenderState

    public init(
      render: RenderState = .empty,
      showFileImporter: Bool = false
    ) {
      self.render = .empty
      self.showFileImporter = showFileImporter
    }
  }

  public enum Action: Equatable, BindableAction {
    case onAppear
    case pressedImportImage
    case importImageAt(URL)
    case importImageFinished(TaskResult<ImageRender>)
    case binding(BindingAction<State>)
    case forParent(AscendingAction)
  }

  public enum AscendingAction: Equatable {
    case didImportNew(ImageRender)
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
        state.render = .workingOn(url)
        state.showFileImporter = false
        return .task(priority: .background) {
          let inputImage = try CGImage.from(fileURL: url)
          return await .importImageFinished(
            TaskResult {
              let renders = try await computeSimulations(inputImage).asPlatformImages()
              return ImageRender(importURL: url, renders: renders)
            }
          )
        } catch: { error in
            .importImageFinished(.failure(error))
        }

      case let .importImageFinished(.success(newRender)):
        state.render = .empty
        return .send(.forParent(.didImportNew(newRender)))

      case let .importImageFinished(.failure(error)):
        print(error)
        state.render = .empty
        return .none

      case .binding:
        return .none

      case .forParent:
        return .none
      }
    }
  }
}
