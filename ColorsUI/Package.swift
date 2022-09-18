// swift-tools-version: 5.7

import PackageDescription

let packageName = "ColorsUI"

let package = Package(
  name: packageName,
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(
      name: packageName,
      targets: [packageName]
    ),
  ],
  dependencies: [
    .package(path: "../ColorVision"),
    .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: "1.0.3")),
  ],
  targets: [
    .target(
      name: packageName,
      dependencies: [
        .byName(name: "ColorVision"),
        .product(name: "OrderedCollections", package: "swift-collections")
      ],
      path: "Sources",
      resources: [.process("Resources")]
    )
  ]
)
