// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI

public struct OnboardingView: View {

  public init() {
  }

  public var body: some View {
    FadedScrollView {
      VStack {
        VStack(alignment: .leading, spacing: 25) {
          ColorBlindWordArt()

          Text("About 4% of men and 0.5% of women see wavelength of light differently than most. You can explore a simulation of what they see using your camera.")

          Text("About 4% of men and 0.5% of women see wavelength of light differently than most. You can explore a simulation of what they see using your camera.")

          Text("About 4% of men and 0.5% of women see wavelength of light differently than most. You can explore a simulation of what they see using your camera.")
        }
        .scenePadding()
        .padding(.bottom, 50)

        VStack(spacing: 0) {
          StripeRow(
            text: "Typical",
            background: .init(colors: [.red, .green])
          )
          StripeRow(
            text: "Deutan",
            background: .init(colors: [.yellow, .blue])
          )
          StripeRow(
            text: "Protan",
            background: .init(colors: [.blue, .yellow])
          )
          StripeRow(
            text: "Tritan",
            background: .init(colors: [.pink, .teal])
          )
          StripeRow(
            text: "Monochromat",
            background: .init(colors: [.gray, .gray.opacity(0.5)])
          )
        }

        VStack(alignment: .leading, spacing: 25) {

          GroupBox("Vision Simulation") {
            Text("Copy goes here.")
          }
          .groupBoxStyle(.elevated)
        }
        .scenePadding()
      }
      .padding(.bottom, 30)
    }
    .background {
      RainbowBackground()
        .edgesIgnoringSafeArea(.all)
        .overlay(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      StartCameraButton(
        action: { }
      )
      .scenePadding([.horizontal, .bottom])
    }
  }
}

struct StripeRow: View {
  let text: String
  let background: Gradient
  let height = 75.0

  var body: some View {
    ZStack(alignment: .bottom) {
      Rectangle()
        .fill(
          LinearGradient(
            gradient: background,
            startPoint: .leading,
            endPoint: .bottomTrailing
          )
        )
        .frame(height: height)
        .padding(.horizontal, -50)

      Text(text)
        .font(.title.weight(.heavy))
        .foregroundStyle(.primary)
        .padding(.leading, 75)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(y: 2)
    }
    .rotationEffect(.degrees(-5), anchor: .leading)
  }
}

struct RainbowBackground: View {

  @State
  private var didAppear = false

  var body: some View {
    ZStack {

      LinearGradient(
        colors:  orangeGreen,
        startPoint: didAppear ? .leading : .topLeading,
        endPoint: didAppear ? .bottomTrailing : .leading
      )
      .opacity(!didAppear ? 1 : 0)

      LinearGradient(
        colors: yellowBlue,
        startPoint: didAppear ? .topLeading : .trailing,
        endPoint: didAppear ? .bottomTrailing : .bottomLeading
      )
      .opacity(didAppear ? 1 : 0)

      LinearGradient(
        colors: redTeal,
        startPoint: didAppear ? .topLeading : .trailing,
        endPoint: didAppear ? .bottomTrailing : .bottomLeading
      )
      .opacity(!didAppear ? 1 : 0)
    }
    .animation(
      .easeOut(duration: 12)
      .repeatForever(autoreverses: true),
      value: didAppear
    )
    .onAppear { didAppear = true }
  }

  private var pinkTeal: [Color] {
    [.pink.opacity(0.75),
     .teal.opacity(0.25)]
  }

  private var orangeGreen: [Color] {
    [.orange.opacity(0.25),
     .green.opacity(0.85)]
  }

  private var yellowBlue: [Color] {
    [.yellow.opacity(0.65),
     .blue.opacity(0.15)]
  }

  private var redTeal: [Color] {
    [.red.opacity(0.25),
     .teal.opacity(0.95)]
  }
}

struct ColorBlindWordArt: View {
  var body: some View {
    HStack {
      GradientText(
        text: "Color",
        stops: [
          .init(color: .black, location: 0.1),
          .init(color: .black.opacity(0.8), location: 0.9)
        ]
      )
      .grayscale(1)

      GradientText(
        text: "blindness",
        stops: [
          .init(color: .red, location: 0.1),
          .init(color: .orange, location: 0.9)
        ]
      )
    }
    .font(.largeTitle.weight(.heavy))
  }
}

struct GradientText: View {
  let text: String
  let stops: [Gradient.Stop]
  var start: UnitPoint = .leading
  var end: UnitPoint = .trailing

  var body: some View {
    Text(text)
      .foregroundStyle(
        LinearGradient(
          gradient: Gradient(stops: stops),
          startPoint: start,
          endPoint: end
        )
      )
  }
}

struct StartCameraButton: View {
  let action: () -> Void

  var body: some View {
    Button(
      action: action,
      label: { label }
    )
    .buttonStyle(.borderedProminent)
  }

  private var label: some View {
    Text(Strings.cta)
      .font(.title3.weight(.medium))
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity)
  }
}

struct VisionTypesBox: View {
  var body: some View {
    GroupBox("Vision Types") {
      Text("Broadly, classified as four types.")
      ScrollView(.horizontal, showsIndicators: true) {
        HStack {
          ForEach(0..<10) { _ in
            RoundedRectangle(cornerRadius: 10)
              .fill(.secondary)
              .frame(width: 50, height: 50)
          }
        }
        .padding(.vertical)
      }
      .padding(.trailing, -ElevatedGroupBoxStyle.interiorContentPadding)
    }
    .groupBoxStyle(.elevated)
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      OnboardingView()
    }
  }
}
#endif

struct Strings {
  static let title = String(
    localized: "What do color blind people see?",
    comment: "Onboarding - Title"
  )

  static let cta = String(
    localized: "Start Camera",
    comment: "Onboarding - Primary call to action button"
  )
}
