// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Dependencies",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(name: "VisionSimulation", targets: ["VisionSimulation"]),
  ],
  dependencies: [
    .package(path: "../ExternalDependencies"),
    .package(path: "../ColorVision"),
  ],
  targets: [
    .target(
      name: "VisionSimulation",
      dependencies: [
        .byName(name: "ColorVision"),
        .product(name: "TCA", package: "ExternalDependencies"),
      ],
      exclude: [
        "Resources/Metal/Machado.air",
        "Resources/Metal/Machado.metal",
      ],
      resources: [
        .copy("Resources/Metal/")
      ]
    ),
  ]
)
