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
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: .init(0, 47, 2)
    ),
    .package(
      url: "https://github.com/johnpatrickmorgan/TCACoordinators",
      from: .init(0, 3, 0)
    ),
  ],
  targets: [
    .target(name: "Root", dependencies: [
      .Internal.ColorsUI,
      "Camera",
      "Onboarding",
      .External.ComposableArchitecture,
      .External.TCACoordinators,
    ]),
    .target(name: "Camera", dependencies: [
      .Clients.Camera,
      .External.ComposableArchitecture,
      .Internal.ColorsUI,
      .Internal.Models,
    ]),
    .target(name: "Onboarding", dependencies: [
      .Internal.ColorsUI,
      .External.ComposableArchitecture
    ]),
    .testTarget(name: "OnboardingTests", dependencies: [
      "Onboarding"
    ]),
  ]
)

// MARK: - Modules

// MARK: - Dependencies

extension Target.Dependency {

  struct Clients {
    static let Camera = Target.Dependency
      .product(
        name: "CameraClient",
        package: "Clients"
      )
  }

  struct Internal {
    static let ColorsUI = Target.Dependency(stringLiteral: "ColorsUI")
    static let Models = Target.Dependency(stringLiteral: "Models")
  }

  struct External {
    static let ComposableArchitecture = Target.Dependency
      .product(
        name: "ComposableArchitecture",
        package: "swift-composable-architecture"
      )
    static let TCACoordinators = Target.Dependency
      .product(
        name: "TCACoordinators",
        package: "TCACoordinators"
      )
  }
}
