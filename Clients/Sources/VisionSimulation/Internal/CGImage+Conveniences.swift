// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

#if os(macOS)
import AppKit

extension CGImage {
  public static func `from`(fileURL: URL) -> CGImage? {
    guard let image = NSImage(contentsOf: fileURL) else { return nil }
    var rect = NSRect(origin: .zero, size: image.size)
    return image.cgImage(forProposedRect: &rect, context: .current, hints: nil)
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

extension CGImage {
  public static func `from`(fileURL: URL) -> CGImage? {
    UIImage(contentsOfFile: fileURL.absoluteString)?.cgImage
  }
}
#endif
