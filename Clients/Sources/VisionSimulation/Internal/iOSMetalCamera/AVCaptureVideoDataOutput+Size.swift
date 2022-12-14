// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import AVKit

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
      )
      .size
  }
}
#endif
