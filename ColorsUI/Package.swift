// swift-tools-version: 5.7

import PackageDescription

let packageName = "ColorsUI"

let package = Package(
  name: packageName,
  platforms: [.iOS(.v15), .macOS(.v13)],
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
