// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v15), .macOS(.v13)],
  products: [
    .library(name: "Root", targets: ["Root"]),
    .library(name: "Onboarding", targets: ["Onboarding"]),
  ],
  dependencies: [
    .package(path: "../ColorsUI")
  ],
  targets: [
    .target(
      name: "Root",
      dependencies: [
        "Onboarding",
      ]
    ),
    .target(
      name: "Onboarding",
      dependencies: [
        "ColorsUI",
      ]
    ),
    .testTarget(
      name: "OnboardingTests",
      dependencies: [
        "Onboarding"
      ]
    ),
  ]
)
