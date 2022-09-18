// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import AVKit

extension AVCaptureVideoOrientation {
  init(_ ui: UIInterfaceOrientation) {
    switch ui {
    case .landscapeRight: self = .landscapeRight
    case .landscapeLeft: self = .landscapeLeft
    case .portraitUpsideDown: self = .portraitUpsideDown
    case .portrait: self = .portrait
    case .unknown: self = .portrait
    @unknown default: self = .portrait
    }
  }

  static func fromCurrentDeviceOrientation() -> Self? {
    switch UIDevice.current.orientation {
    case .faceDown: return nil
    case .faceUp: return nil
    case .landscapeRight: return .landscapeLeft
    case .landscapeLeft: return .landscapeRight
    case .portrait: return .portrait
    case .portraitUpsideDown: return .portraitUpsideDown
    case .unknown: return nil
    @unknown default: return nil
    }
  }

  var isLandscape: Bool { self == .landscapeLeft || self == .landscapeRight }
}


extension AVCaptureVideoDataOutput {
  var outputSize: CGSize? {
    connections
      .first?
      .output?
      .outputRectConverted(
        fromMetadataOutputRect: .init(
          origin: .zero,
          size: .init(width: 1, height: 1)
        )
      ).size
  }
}


extension UIView {
  var isPortrait: Bool { bounds.height > bounds.width }
}

extension CGSize {
  var isPortrait: Bool { height > width }
}
#endif
