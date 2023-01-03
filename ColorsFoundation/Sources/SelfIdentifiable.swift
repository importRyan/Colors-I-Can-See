// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Foundation

public protocol SelfIdentifiable: Hashable, Identifiable {
  var id: Self { get }
}

extension SelfIdentifiable {
  public var id: Self { self }
}
