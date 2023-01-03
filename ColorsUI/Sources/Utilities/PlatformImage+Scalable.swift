// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

#if canImport(AppKit)
public typealias PlatformImage = NSImage
#elseif canImport(UIKit)
public typealias PlatformImage = UIImage
#endif

#if canImport(AppKit)
extension NSImage: Scalable {
  public var image: Image { Image(nsImage: self) }
  public var aspectRatio: CGFloat { self.size.width / self.size.height }
}
#elseif canImport(UIKit)
extension UIImage: Scalable {
  public var image: Image { Image(uiImage: self) }
  public var aspectRatio: CGFloat { self.size.width / self.size.height }
}
#endif

public protocol Scalable {
  var aspectRatio: CGFloat { get }
  var size: CGSize { get }
}

extension CGSize: Scalable {
  public var aspectRatio: CGFloat { self.width / self.height }
  public var size: CGSize { self }
}

extension Scalable {
  public func scaleWidth(max: CGFloat) -> CGFloat {
    if aspectRatio >= 1 { return max }
    return aspectRatio * max
  }

  public func scaleHeight(max: CGFloat) -> CGFloat {
    if aspectRatio <= 1 { return max }
    return max / aspectRatio
  }
}

