// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v16), .macOS(.v13)],
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
