// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Foundation

extension Set {
  public mutating func toggle(_ element: Element) {
    if self.contains(element) {
      self.remove(element)
    } else {
      self.insert(element)
    }
  }
}
