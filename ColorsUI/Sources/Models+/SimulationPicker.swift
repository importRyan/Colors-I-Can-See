// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI
import VisionType

public struct SimulationPicker: View {

  public init(simulation: Binding<VisionType>) {
    _simulation = simulation
  }

  @Binding var simulation: VisionType

  public var body: some View {
    Picker("Simulation", selection: $simulation) {
      ForEach(VisionType.allCases) { vision in
        Text(vision.localizedInfo.shortName)
          .tag(vision)
      }
    }
  }
}
