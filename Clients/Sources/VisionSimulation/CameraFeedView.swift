// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct CameraFeedView: View {
  public init() { }
  public var body: some View {
#if targetEnvironment(simulator)
    SimulatorMock()
      .edgesIgnoringSafeArea(.all)

#elseif os(iOS)
    iOSHostedMetalCamera(metal: metal)
      .edgesIgnoringSafeArea(.all)

#elseif os(macOS)
    macOSHostedMetalCamera(metal: metal)
      .edgesIgnoringSafeArea(.all)

#endif
  }
}

// MARK: - Implementations

#if os(iOS)
struct iOSHostedMetalCamera: UIViewControllerRepresentable {
  let metal: MetalAssetStore
  func makeUIViewController(context: Context) -> MTKViewHostController {
    .init(metal: metal)
  }
  func updateUIViewController(_ vc: MTKViewHostController, context: Context) {
  }
}
#elseif os(macOS)
struct macOSHostedMetalCamera: NSViewControllerRepresentable {
  let metal: MetalAssetStore
  func makeNSViewController(context: Context) -> MTKViewHostController {
    .init(metal: metal)
  }
  func updateNSViewController(_ vc: MTKViewHostController, context: Context) {
  }
}
#endif

#if DEBUG
struct SimulatorMock: View {
  var body: some View {
    Text(verbatim: "Mock camera for iOS simulator.")
      .foregroundStyle(.secondary)
      .font(.caption)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.black)
  }
}
#endif
