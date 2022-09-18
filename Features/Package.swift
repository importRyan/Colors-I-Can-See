// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(name: "Root", targets: ["Root"]),
    .library(name: "Camera", targets: ["Camera"]),
    .library(name: "Onboarding", targets: ["Onboarding"]),
  ],
  dependencies: [
    .package(path: "../ColorsUI"),
    .package(path: "../Clients"),
    .package(path: "../Models"),
  ],
  targets: [
    .target(name: "Root", dependencies: [
      "ColorsUI",
      "Camera",
      "Onboarding",
    ]),
    .target(name: "Camera", dependencies: [
      "ColorsUI",
      .byName(name: "Models"),
      .product(name: "CameraClient", package: "Clients")
    ]),
    .target(name: "Onboarding", dependencies: [
      "ColorsUI",
    ]),
    .testTarget(name: "OnboardingTests", dependencies: [
      "Onboarding"
    ]),
  ]
)
