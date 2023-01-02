// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI

extension Tabs.Tab {

  @ViewBuilder
  func label() -> some View {
    switch self {
    case .learn: CLabel("Learn", symbol: .learn)
    case .camera: CLabel("Camera", symbol: .camera)
    case .image: CLabel("Images", symbol: .image)
    }
  }
}
