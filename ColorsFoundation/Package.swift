// swift-tools-version: 5.7

import PackageDescription

let packageName = "ColorsFoundation"

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
    .library(name: packageName, targets: [packageName]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: packageName,
      dependencies: [],
      path: "Sources"
    ),
  ]
)
