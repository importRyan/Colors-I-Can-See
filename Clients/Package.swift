// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Clients",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(name: "TCA", targets: ["TCA"]),
    .library(name: "VisionSimulation", targets: ["VisionSimulation"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: .init(0, 47, 2)
    ),
    .package(path: "../ColorVision"),
  ],
  targets: [
    .target(
      name: "TCA",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "VisionSimulation",
      dependencies: [
        .byName(name: "ColorVision"),
        .byName(name: "TCA"),
      ],
      exclude: [
        "Resources/Metal/Machado.air",
        "Resources/Metal/Machado.metal",
      ],
      resources: [
        .copy("Resources/Metal/")
      ]
    )
  ]
)
