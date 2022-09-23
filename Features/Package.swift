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
      branch: "protocol-beta"
    ),
  ],
  targets: [
    .target(name: "Root", dependencies: [
      .Internal.ColorsUI,
      "Camera",
      "Onboarding",
    ]),
    .target(name: "Camera", dependencies: [
      .Clients.Camera,
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
  }
}
