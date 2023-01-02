// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

public protocol AccessibilityLabeledImage {
  var image: ModifiedContent<Image, AccessibilityAttachmentModifier> { get }
}
