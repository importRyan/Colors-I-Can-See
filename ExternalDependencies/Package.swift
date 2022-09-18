// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "ExternalDependencies",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(name: "TCA", targets: ["TCA"]),
    .library(name: "TCAC", targets: ["TCAC"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: .init(0, 47, 2)
    ),
    .package(
      url: "https://github.com/johnpatrickmorgan/TCACoordinators",
      from: .init(0, 3, 0)
    ),
  ],
  targets: [
    .target(
      name: "TCA",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "TCAC",
      dependencies: [
        .product(name: "TCACoordinators", package: "TCACoordinators")
      ]
    )
  ]
)
