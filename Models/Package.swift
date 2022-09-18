// swift-tools-version: 5.7

import PackageDescription

let packageName = "Models"

let package = Package(
  name: packageName,
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(
      name: packageName,
      targets: [packageName]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: packageName,
      dependencies: [],
      path: "Sources"
    )
  ]
)
