// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

public enum SFSymbol: String, CaseIterable {
  case camera = "camera"
  case image = "photo"
  case learn = "book"
  case play = "play"
  case pause = "pause"
  case visionSimulation = "eye"
}

extension SFSymbol {
  public var accessibilityLabel: String {
    switch self {
    case .camera: return "Camera"
    case .image: return "Images"
    case .learn: return "Learn"
    case .play: return "Play"
    case .pause: return "Pause"
    case .visionSimulation: return "Vision Simulation"
    }
  }
}

extension SFSymbol: View, AccessibilityLabeledImage {

  public var image: ModifiedContent<Image, AccessibilityAttachmentModifier> {
    Image(systemName: self.rawValue)
      .accessibilityLabel(self.accessibilityLabel)
  }

  public var body: some View {
    self.image
  }
}
