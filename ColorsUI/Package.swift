// swift-tools-version: 5.7

import PackageDescription

let packageName = "ColorsUI"

let package = Package(
  name: packageName,
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(
      name: packageName,
      targets: [packageName]
    ),
  ],
  dependencies: [
    .package(path: "../Models"),
  ],
  targets: [
    .target(
      name: packageName,
      dependencies: [
        .byName(name: "Models"),
      ],
      path: "Sources"
    )
  ]
)
