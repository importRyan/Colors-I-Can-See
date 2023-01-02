// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "ColorVision",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(
      name: "VisionType",
      targets: ["VisionType"]
    ),
    .library(
      name: "CPUColorVisionSimulation",
      targets: ["CPUColorVisionSimulation", "VisionType", "ColorVectors"]
    ),
    .library(
      name: "MetalColorVisionSimulation",
      targets: ["MetalColorVisionSimulation", "VisionType"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "VisionType",
      dependencies: []
    ),
    .target(
      name: "ColorVectors",
      dependencies: []
    ),
    .target(
      name: "ColorBlindnessTransforms",
      dependencies: ["ColorVectors", "VisionType"]
    ),
    .target(
      name: "CPUColorVisionSimulation",
      dependencies: ["ColorVectors", "ColorBlindnessTransforms", "VisionType"]
    ),
    .target(
      name: "MetalColorVisionSimulation",
      dependencies: ["ColorVectors", "ColorBlindnessTransforms", "VisionType"]
    )
  ]
)
