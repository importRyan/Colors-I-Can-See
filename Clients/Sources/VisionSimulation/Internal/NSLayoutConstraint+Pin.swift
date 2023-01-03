// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import UIKit
typealias SomeView = UIView
#elseif canImport(AppKit)
import AppKit
typealias SomeView = NSView
#endif

extension Array where Element == NSLayoutConstraint {

  static func pinning(_ view: SomeView, to parent: SomeView) -> Self {
    [
      view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
      view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      view.topAnchor.constraint(equalTo: parent.topAnchor)
    ]
  }
}

extension SomeView {

  func constrain(_ subview: SomeView, constraints: () -> [NSLayoutConstraint] ) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraints())
  }

  func pinToBounds(_ subview: SomeView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(.pinning(subview, to: self))
  }
}
