// Copyright 2022 by Ryan Ferrell. @importRyan

import CameraClient
import ColorsUI

public struct CameraView: View {
  public init() { }
  public var body: some View {
    ZStack(alignment: .topLeading) {
      CameraFeed()
      CameraControlsView()
    }
  }
}
