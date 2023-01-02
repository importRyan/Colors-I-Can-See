// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Features",
  defaultLocalization: "en",
  platforms: [.iOS(.v16), .macOS(.v13)],
  products: [
    .library(name: "Root", targets: ["Root"]),
    .library(name: "Camera", targets: ["Camera"]),
    .library(name: "Images", targets: ["Images"]),
    .library(name: "Learn", targets: ["Learn"]),
    .library(name: "Onboarding", targets: ["Onboarding"]),
    .library(name: "Tabs", targets: ["Tabs"]),
  ],
  dependencies: [
    .package(path: "../ColorsFoundation"),
    .package(path: "../ColorsUI"),
    .package(path: "../ColorVision"),
    .package(path: "../Clients"),
    .package(
      url: "https://github.com/johnpatrickmorgan/TCACoordinators",
      from: .init(0, 3, 0)
    ),
  ],
  targets: [
    .target(name: "Root", dependencies: [
      .Clients.VisionSimulation,
      .Internal.ColorsUI,
      .Internal.Foundation,
      .External.ComposableArchitecture,
      .External.TCACoordinators,
      "Onboarding",
      "Tabs",
    ]),
    .target(name: "Images", dependencies: [
      .Clients.VisionSimulation,
      .Internal.ColorsUI,
      .External.ComposableArchitecture,
      .External.TCACoordinators,
    ]),
    .target(
      name: "Camera",
      dependencies: [
        .Clients.VisionSimulation,
        .External.ComposableArchitecture,
        .Internal.ColorsUI,
        .Internal.Models,
      ],
      resources: [.process("Resources")]
    ),
    .testTarget(name: "CameraTests", dependencies: [
      "Camera"
    ]),
    .target(
      name: "Learn",
      dependencies: [
        .Internal.ColorsUI,
        .External.ComposableArchitecture,
        .External.TCACoordinators,
      ],
      resources: [.process("Resources")]
    ),
    .testTarget(name: "LearnTests", dependencies: [
      "Learn"
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
    .target(name: "Tabs", dependencies: [
      .External.ComposableArchitecture,
      .Internal.ColorsUI,
      .Internal.Models,
      "Camera",
      "Learn",
    ]),
  ]
)

// MARK: - Modules

// MARK: - Dependencies

extension Target.Dependency {

  struct Clients {
    static let VisionSimulation = Target.Dependency
      .product(name: "VisionSimulation", package: "Clients")
  }

  struct Internal {
    static let ColorsUI = Target.Dependency(stringLiteral: "ColorsUI")
    static let Foundation = Target.Dependency(stringLiteral: "ColorsFoundation")
    static let Models = Target.Dependency.product(name: "VisionType", package: "ColorVision")
  }

  struct External {
    static let ComposableArchitecture = Target.Dependency
      .product(name: "TCA", package: "Clients")
    static let TCACoordinators = Target.Dependency
      .product(name: "TCACoordinators", package: "TCACoordinators")
  }
}
