// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct CameraFeed: View {
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
  func makeUIViewController(context: Context) -> MTKViewController {
    .init(metal: metal)
  }
  func updateUIViewController(_ vc: MTKViewController, context: Context) {
  }
}
#elseif os(macOS)
struct macOSHostedMetalCamera: NSViewControllerRepresentable {
  let metal: MetalAssetStore
  func makeNSViewController(context: Context) -> MTKViewController {
    .init(metal: metal)
  }
  func updateNSViewController(_ vc: MTKViewController, context: Context) {
  }
}
#endif



#if DEBUG
struct SimulatorMock: View {

  var body: some View {
    Text("Mock camera for iOS simulator.")
      .foregroundStyle(.secondary)
      .font(.caption)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.black)
  }
}
#endif
