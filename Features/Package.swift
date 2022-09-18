// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Features",
  defaultLocalization: "en",
  platforms: [.iOS(.v16), .macOS(.v13)],
  products: [
    .library(name: "Root", targets: ["Root"]),
    .library(name: "Camera", targets: ["Camera"]),
    .library(name: "CameraFlow", targets: ["CameraFlow"]),
    .library(name: "Onboarding", targets: ["Onboarding"]),
  ],
  dependencies: [
    .package(path: "../ColorsUI"),
    .package(path: "../ColorVision"),
    .package(path: "../Dependencies"),
    .package(path: "../ExternalDependencies"),
  ],
  targets: [
    .target(name: "Root", dependencies: [
      .Clients.VisionSimulation,
      .Internal.ColorsUI,
      "CameraFlow",
      "Onboarding",
      .External.ComposableArchitecture,
      .External.TCACoordinators,
    ]),
    .target(name: "CameraFlow", dependencies: [
      .Internal.ColorsUI,
      "Camera",
      .External.ComposableArchitecture,
      .External.TCACoordinators,
    ]),
    .target(name: "Camera", dependencies: [
      .Clients.VisionSimulation,
      .External.ComposableArchitecture,
      .Internal.ColorsUI,
      .Internal.Models,
    ]),
    .target(
      name: "Onboarding",
      dependencies: [
        .Internal.ColorsUI,
        .External.ComposableArchitecture,
        .External.TCACoordinators,
      ],
      resources: [.process("Resources")]
    ),
    .testTarget(name: "OnboardingTests", dependencies: [
      "Onboarding"
    ]),
  ]
)

// MARK: - Modules

// MARK: - Dependencies

extension Target.Dependency {

  struct Clients {
    static let VisionSimulation = Target.Dependency
      .product(name: "VisionSimulation", package: "Dependencies")
  }

  struct Internal {
    static let ColorsUI = Target.Dependency(stringLiteral: "ColorsUI")
    static let Models = Target.Dependency(stringLiteral: "ColorVision")
  }

  struct External {
    static let ComposableArchitecture = Target.Dependency
      .product(name: "TCA", package: "ExternalDependencies")
    static let TCACoordinators = Target.Dependency
      .product(name: "TCAC", package: "ExternalDependencies")
  }
}
