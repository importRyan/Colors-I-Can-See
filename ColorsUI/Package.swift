// swift-tools-version: 5.7

import PackageDescription

let packageName = "ColorsUI"

let package = Package(
  name: packageName,
  platforms: [.iOS(.v16), .macOS(.v13)],
  products: [
    .library(
      name: packageName,
      targets: [packageName]
    ),
  ],
  dependencies: [
    .package(path: "../Models"),
    .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: "1.0.3")),
  ],
  targets: [
    .target(
      name: packageName,
      dependencies: [
        .byName(name: "Models"),
        .product(name: "OrderedCollections", package: "swift-collections")
      ],
      path: "Sources"
    )
  ]
)
