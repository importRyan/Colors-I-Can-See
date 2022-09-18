// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation

extension CGRect {
  func zeroOrigin() -> Self {
    CGRect(origin: .zero, size: size)
  }
}

extension CGSize {
  func zeroOriginRect() -> CGRect {
    CGRect(origin: .zero, size: self)
  }
}
