// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

struct VisionCard: View {
  let vision: VisionType
  let carouselSize: CGSize
  let onTap: () -> Void

  @State var hideSimulation = false

  var body: some View {
    cardContents
      .onTapGesture(perform: onTap)
      .frame(
        width: carouselSize.width * 0.8,
        height: carouselSize.height,
        alignment: .topLeading
      )
  }

  private var cardContents: some View {
    VStack(alignment: .leading, spacing: 0) {

      HueSimulation(
        hideSimulation: $hideSimulation,
        vision: vision
      )
      .frame(height: carouselSize.height * 0.45)

      VStack(alignment: .leading, spacing: 15) {
        ToolbarRow(
          hideSimulation: $hideSimulation,
          showToggleSimulationButton: vision != .typical,
          info: vision.localizedInfo
        )

        Details(
          info: vision.localizedInfo
        )
      }
      .scenePadding()
    }
    .background(Color(uiColor: .systemBackground))
    .clipShape(clipShape)
    .compositingGroup()
  }

  private var clipShape: RoundedRectangle {
    RoundedRectangle(cornerRadius: 20, style: .continuous)
  }
}

fileprivate struct Details: View {
  let info: VisionType.LocalizedInformation

  var body: some View {
    VStack(alignment: .leading) {
      Text(info.fullIntensityName)
        .font(.title2.weight(.semibold))
    }

    ScrollView {
      Text(info.explanation)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(.callout)
    }

    if let colloquialType = info.colloquialType {
      Text(colloquialType.localizedUppercase)
        .foregroundColor(.secondary)
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
  }
}

fileprivate struct HueSimulation: View {

  @Binding var hideSimulation: Bool
  let vision: VisionType

  var body: some View {
    simulatedVisionGradient
      .overlay {
        if hideSimulation {
          typicalVisionGradient
            .transition(.opacity)
        }
      }
      .drawingGroup(opaque: true, colorMode: .extendedLinear)
  }

  private var simulatedVisionGradient: AngularGradient {
    AngularGradient(
      gradient: Gradient.rainbow(in: vision),
      center: .center,
      startAngle: .degrees(-90),
      endAngle: .degrees(360 - 90)
    )
  }

  private var typicalVisionGradient: AngularGradient {
    AngularGradient(
      gradient: .rainbow(in: .typical),
      center: .center,
      startAngle: .degrees(-90),
      endAngle: .degrees(360 - 90)
    )
  }
}

fileprivate struct ToolbarRow: View {

  @Binding var hideSimulation: Bool
  let showToggleSimulationButton: Bool
  let info: VisionType.LocalizedInformation

  var body: some View {
    HStack {
      PopulationLabel(
        label: "♂",
        percentage: info.frequency.men
      )
      .padding(.trailing, 8)

      PopulationLabel(
        label: "♀",
        percentage: info.frequency.women
      )

      Spacer()

      if showToggleSimulationButton {
        Button("Hide Simulation") {}
          .foregroundColor(.accentColor)
          .buttonStyle(ActionWhilePressedButtonStyle(isPressed: $hideSimulation))
          .font(.caption2)
      }
    }
  }

  private struct PopulationLabel: View {
    let label: String
    let percentage: Double

    var body: some View {
      HStack(spacing: 2) {
        Text(label)
          .fontWeight(.medium)
          .baselineOffset(6)
          .foregroundStyle(.secondary)

        Text(percentage, format: .percent)
          .fontWeight(.semibold)
          .foregroundStyle(.secondary)
      }
      .font(.caption)
    }
  }
}
