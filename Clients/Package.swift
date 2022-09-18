// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Clients",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(name: "CameraClient", targets: ["CameraClient"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "CameraClient", dependencies: [
    ]),
    .testTarget(name: "CameraClientTests", dependencies: [
      "CameraClient"
    ]),
  ]
)
