// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI
import VisionType

#if os(macOS)
import AppKit

extension [VisionType: CIImage] {
  public func asPlatformImages() -> [VisionType: NSImage] {
    self
      .mapValues(NSBitmapImageRep.init(ciImage:))
      .mapValues(NSImage.init(bitmapRep:))
  }
}

extension CGImage {
  public static func `from`(fileURL: URL) throws -> CGImage {
    guard let loadedImage = NSImage(contentsOf: fileURL) else {
      throw CocoaError(.fileReadUnknown)
    }
    var rect = NSRect(
      origin: .zero,
      size: loadedImage.size
    )
    guard let cgImage = loadedImage .cgImage(
      forProposedRect: &rect,
      context: .current,
      hints: nil
    ) else {
      throw CocoaError(.fileReadUnsupportedScheme)
    }
    return cgImage
  }
}

extension NSImage {
  public convenience init(bitmapRep: NSBitmapImageRep) {
    self.init(size: bitmapRep.size)
    self.addRepresentation(bitmapRep)
  }
}

#elseif os(iOS)
import UIKit

extension [VisionType: CIImage] {
  public func asPlatformImages() -> [VisionType: UIImage] {
    self
      .mapValues(UIImage.init(ciImage:))
  }
}

extension CGImage {
  public static func `from`(fileURL: URL) throws -> CGImage {
    let data = try Data(contentsOf: fileURL)
    guard let imageFromFile = UIImage(data: data) else {
      throw CocoaError(.fileReadUnsupportedScheme)
    }
    guard let cgImage = imageFromFile.cgImage else {
      throw CocoaError(.fileReadUnknown)
    }
    return cgImage
  }
}
#endif
