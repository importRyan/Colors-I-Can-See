// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

public enum SFSymbol: String, CaseIterable {
  case camera = "camera"
  case image = "photo"
  case learn = "book"
}

extension SFSymbol {
  public var accessibilityLabel: String {
    switch self {
    case .camera: return "Camera"
    case .image: return "Images"
    case .learn: return "Learn"
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
