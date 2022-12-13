// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import UIKit

extension Array where Element == NSLayoutConstraint {

  static func pinning(_ view: UIView, to parent: UIView) -> Self {
    [
      view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
      view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      view.topAnchor.constraint(equalTo: parent.topAnchor)
    ]
  }
}

extension UIView {

  func constrain(_ subview: UIView, constraints: () -> [NSLayoutConstraint] ) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraints())
  }

  func pinToBounds(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(.pinning(subview, to: self))
  }
}
#endif
