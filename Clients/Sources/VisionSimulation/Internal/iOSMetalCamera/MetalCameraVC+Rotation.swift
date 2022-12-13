// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import UIKit
import AVKit

extension MetalCameraVC {

  /// I'd prefer not to do this, but affine transform and VC orientation overrides did not work.
  func updateAVCaptureOrientation() {

    if let update = AVCaptureVideoOrientation.fromCurrentDeviceOrientation() {
      session?.connections.first?.videoOrientation = update
      lastOrientation = update
    }
  }
}
#endif
