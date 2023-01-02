// Copyright 2022 by Ryan Ferrell. @importRyan

import CPUColorVisionSimulation
import ColorVectors
import SwiftUI
import VisionType

extension Gradient {
  public static func rainbow(in vision: VisionType) -> Self {
    rainbows[vision]!
  }

  private static let rainbows: [VisionType: Gradient] = Dictionary(
    uniqueKeysWithValues: VisionType
      .allCases
      .map { vision in
        let colors = [Color].rainbow(in: vision)
        return (vision, Gradient(colors: colors))
      }
  )
}

extension Array<Color> {
  public static func rainbow(
    in vision: VisionType,
    _ simulator: ColorBlindnessSimulation = .standard,
    strideLength: Int = 10
  ) -> [Color] {
    stride(from: 0, through: 360, by: strideLength)
      .map {
        let hue = ColorChannel($0) / 360
        let hsv = HSV(hue, 1, 1)
        let vector = RGBVector(hsv: hsv)
        let simulatedColor = simulator.simulate(vision, severity: 1, for: vector)
        return .init(vector: simulatedColor)
      }
  }
}
