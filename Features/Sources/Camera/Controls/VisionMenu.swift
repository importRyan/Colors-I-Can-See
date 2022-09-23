// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

struct VisionMenu: View {
  @Binding var simulation: VisionType

  var body: some View {

    Menu {
      Text("Color blindness simulations")
      VisionPicker(simulation: $simulation)
    } label: {
      HStack {
        VisionFilterStateIcon(current: simulation)
        if simulation == .typical {
          Text("Choose a simulation")
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
        } else {
          Text(simulation.localizedInfo.shortName)
            .foregroundColor(simulation.textColor)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
        }
      }
      .font(.callout.weight(.semibold))
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .background(.quaternary, in: RoundedRectangle(cornerRadius: 15))
      .animation(.linear(duration: 0.15), value: simulation)
    }
  }
}

struct VisionPicker: View {
  @Binding var simulation: VisionType

  var body: some View {
    Picker(selection: $simulation) {
      ForEach(VisionType.allCases) { vision in
        Text(vision.localizedInfo.shortName)
          .tag(vision)
      }
    } label: {
      Text("Vision Types")
    }
  }
}
