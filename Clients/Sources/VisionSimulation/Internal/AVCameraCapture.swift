// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import AVFoundation
import Foundation

final class AVCameraCapture: NSObject {

  init(
    queue: DispatchQueue,
    didCaptureFrame: @escaping (CMSampleBuffer) -> Void
  ) {
    self.didCaptureFrame = didCaptureFrame
    self.queue = queue
  }

  var session: AVCaptureSession?
  var devices: [AVCaptureDevice] = []
  var currentInputDevice: AVCaptureDevice?
  var queue: DispatchQueue
  var didCaptureFrame: (CMSampleBuffer) -> Void
}

extension AVCameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    didCaptureFrame(sampleBuffer)
  }
}

// MARK: - Intents

extension AVCameraCapture {

  func startCamera() async throws -> CameraSuccess {
    try await withCheckedThrowingContinuation { continuation in
      queue.sync { [self] in
        do {
          let session = AVCaptureSession()
          session.beginConfiguration()
          discoverDevices()
          try setupInput(for: session)
          try setupOutput(for: session)
          session.connections.first?.videoOrientation = .portrait
          session.commitConfiguration()
          currentInputDevice?.unlockForConfiguration()
          session.startRunning()
          self.session = session
          continuation.resume(with: .success(.init()))
        } catch {
          continuation.resume(with: .failure(error))
        }
      }
    }
  }

  func stopCamera() {
    queue.async {
      self.session?.stopRunning()
    }
  }

  func restartCamera() {
    queue.async {
      self.session?.startRunning()
    }
  }
}

// MARK: - Setup

extension AVCameraCapture {
  private func discoverDevices() {
#if os(macOS)
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInWideAngleCamera, .externalUnknown],
      mediaType: .video,
      position: .front
    )
#elseif os(iOS)
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInTripleCamera, .builtInDualCamera],
      mediaType: .video,
      position: .back
    )
#endif
    self.devices = discoverySession.devices
  }

  private func setupInput(for session: AVCaptureSession) throws {
    guard let inputDevice = self.devices.first else {
      throw CameraError.noDevicesFound
    }
    let input = try AVCaptureDeviceInput(device: inputDevice)
    try inputDevice.lockForConfiguration()
    guard session.canAddInput(input) else {
      throw CameraError.cannotUseCameraInput
    }
    session.addInput(input)
    self.currentInputDevice = inputDevice
  }

  private func setupOutput(for session: AVCaptureSession) throws {
    let output = AVCaptureVideoDataOutput()
    output.alwaysDiscardsLateVideoFrames = true
    output.setSampleBufferDelegate(self, queue: self.queue)
    output.videoSettings = [
      kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
    ]
    guard session.canAddOutput(output) else {
      throw CameraError.cannotSetupCameraDataOutput
    }
    session.addOutput(output)
  }
}

// MARK: - Authorization

extension AVCameraCapture {

  static func currentAuthorizationStatus() -> Result<AuthorizationSuccess, AuthorizationError> {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: return .success(.init())
    case .denied: return .failure(.denied)
    case .notDetermined: return .failure(.notDetermined)
    case .restricted: return .failure(.restricted)
    @unknown default: return .failure(.unknown)
    }
  }

  static func authorize() async -> Result<AuthorizationSuccess, AuthorizationError> {
    let didAuthorize = await AVCaptureDevice.requestAccess(for: .video)
    if didAuthorize {
      return .success(.init())
    }
    return Self.currentAuthorizationStatus()
  }
}
