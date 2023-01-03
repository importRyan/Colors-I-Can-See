// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI
import VisionType

public struct ImageRender: Equatable, Identifiable, Hashable {
  public var id: URL { importURL }
  public var importURL: URL
  public var renders: [VisionType: PlatformImage]

  public init(importURL: URL, renders: [VisionType : PlatformImage]) {
    self.importURL = importURL
    self.renders = renders
  }
}

public enum RenderState: Equatable, Identifiable, Hashable {
  case empty
  case workingOn(URL)
  case rendered(ImageRender)

  public var id: URL? {
    switch self {
    case .empty: return nil
    case let .workingOn(url): return url
    case let .rendered(images): return images.id
    }
  }

  public var completedRender: ImageRender? {
    if case let .rendered(render) = self {
      return render
    }
    return nil
  }
}
