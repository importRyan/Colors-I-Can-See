// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI
import Models

struct VisionCard: View {
  let vision: VisionType

  @State var hideSimulation = false

  var body: some View {

    let info = vision.localizedInfo

    let typicalOverlayGradient = AngularGradient(
      gradient: .rainbow(in: .typical),
      center: .center,
      startAngle: .degrees(-90),
      endAngle: .degrees(360 - 90)
    )

    let rainbow = Gradient.rainbow(in: vision)
    let gradient = AngularGradient(
      gradient: rainbow,
      center: .center,
      startAngle: .degrees(-90),
      endAngle: .degrees(360 - 90)
    )

    return VStack(alignment: .leading, spacing: 0) {
      gradient
        .drawingGroup(opaque: true, colorMode: .extendedLinear)
        .frame(height: UIScreen.main.bounds.height * 0.35)
        .overlay {
          if hideSimulation {
            typicalOverlayGradient
              .drawingGroup(opaque: true, colorMode: .extendedLinear)
              .transition(.opacity)
          }
        }

      VStack(alignment: .leading, spacing: 15) {
        HStack {
          HStack(spacing: 2) {
            Text("♂")
              .fontWeight(.medium)
              .baselineOffset(7)
              .foregroundStyle(.secondary)

            Text(info.frequency.men, format: .percent)
              .fontWeight(.semibold)
              .foregroundStyle(.secondary)
          }
          .font(.caption)
          .padding(.trailing, 8)

          HStack(spacing: 2) {
            Text("♀")
              .fontWeight(.medium)
              .baselineOffset(5)
              .foregroundStyle(.secondary)

            Text(info.frequency.women, format: .percent)
              .fontWeight(.semibold)
              .foregroundStyle(.secondary)
          }
          .font(.caption)

          Spacer()

          if vision != .typical {
            Button("Hide Simulation") {}
              .foregroundColor(.accentColor)
              .buttonStyle(ActionWhilePressedButtonStyle(isPressed: $hideSimulation))
          }
        }
        .font(.caption2)

        VStack(alignment: .leading) {
          Text(info.fullIntensityName)
            .font(.title2.weight(.semibold))
        }

        Text(info.explanation)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .font(.callout)

        Spacer()

        if let colloquialType = info.colloquialType {
          Text(colloquialType.localizedUppercase)
            .foregroundColor(.secondary)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
      }
      .scenePadding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    .compositingGroup()
    .frame(
      width: UIScreen.main.bounds.width * 0.8,
      height: UIScreen.main.bounds.height * 0.6,
      alignment: .topLeading
    )
  }
}
