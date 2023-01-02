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
    .package(
      url: "https://github.com/apple/swift-async-algorithms",
      from: .init(0, 0, 3)
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
    .testTarget(
      name: "TCATests",
      dependencies: ["TCA"]
    ),
    .target(
      name: "VisionSimulation",
      dependencies: [
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
        .product(name: "MetalColorVisionSimulation", package: "ColorVision"),
        .byName(name: "TCA"),
      ],
      resources: [.process("Resources")]
    )
  ]
)
