// Copyright 2022 by Ryan Ferrell. @importRyan

import VisionType
import SwiftUI

public struct VisionFilterStateIcon: View {

  public init(current: VisionType) {
    self.current = current
  }

  private let current: VisionType

  public var body: some View {
    switch current {
    case .typical:
      unfiltered
    default:
      filtered
        .foregroundStyle(current.primaryColor, current.secondaryColor)
    }
  }

  private var unfiltered: Image {
    Image(systemName: "eye")
  }

  private var filtered: Image {
    Image(systemName: "eye.circle.fill")
  }
}
