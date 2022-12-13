// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct CameraFeed: View {
  public init() { }
  public var body: some View {
#if targetEnvironment(simulator)
    SimulatorMock()
      .edgesIgnoringSafeArea(.all)

#elseif os(iOS)
    iOSHostedMetalCamera(metal: .live!)
      .edgesIgnoringSafeArea(.all)

#elseif os(macOS)
    macOSMock()
      .edgesIgnoringSafeArea(.all)
#endif
  }
}

// MARK: - Implementations

#if DEBUG
struct SimulatorMock: View {

  var body: some View {
    ZStack {
      Color.black
      Text("Mock camera for iOS simulator.")
        .foregroundStyle(.secondary)
        .font(.caption)
    }
  }
}
#endif

#if os(iOS)
struct iOSHostedMetalCamera: UIViewControllerRepresentable {

  let metal: MetalController

  func makeUIViewController(context: Context) -> MetalCameraVC {
    .init(
      device: metal.device,
      commandQueue: metal.realtimeCommandQueue,
      queue: metal.queue,
      controller: metal
    )
  }

  func updateUIViewController(_ uiViewController: MetalCameraVC, context: Context) {

  }
}
#endif

#if os(macOS)
struct macOSMock: View {
  var body: some View {
    ZStack {
      Color.black
      Text("Temporary mock camera for macOS.")
        .foregroundStyle(.secondary)
        .font(.caption)
    }
  }
}
#endif
