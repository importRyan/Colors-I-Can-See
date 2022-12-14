// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import UIKit
import AVFoundation
import MetalKit
import Combine

extension MetalCameraVC {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mtkView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mtkView.translatesAutoresizingMaskIntoConstraints = false
    view.pinToBounds(mtkView)
  }

  /// Expects that prior VCs handled permissions so that MTKView can be built unstopped
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    videoOutputQueue.async { [weak self] in
      self?.setupMetal()
      self?.setupAVCaptureSession()
      self?.monitorSceneChanges()
    }
  }
}

// MARK: - 1 Metal & Filter

extension MetalCameraVC {

  func setupMetal(){
    mtkView.device = metalDevice
    mtkView.isPaused = true
    mtkView.enableSetNeedsDisplay = false
    mtkView.delegate = self
    mtkView.framebufferOnly = false

    ciContext = CIContext(
      mtlDevice: metalDevice,
      options: [.workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!])
  }
}

// MARK: - 2 AVCapture

private extension MetalCameraVC {

  func setupAVCaptureSession() {
    session = AVCaptureSession()
    session?.beginConfiguration()
    session?.automaticallyConfiguresCaptureDeviceForWideColor = false
    setupAVInputs()
    setupAVOutputs()
    transformVideoToScreenEdges()
    session?.automaticallyConfiguresApplicationAudioSession = false
    session?.usesApplicationAudioSession = false

    session?.commitConfiguration()
    session?.startRunning()
    updateExposureDelegate()
  }

  func setupAVInputs() {
    guard let back = setupBackCamera(),
          let front = setupSelfieCamera(),
          let backInput = try? AVCaptureDeviceInput(device: back),
          let frontInput = try? AVCaptureDeviceInput(device: front),
          session?.canAddInput(backInput) == true else {
      fatalError("Rear camera not available for use")
    }
    backCamera = back
    selfieCamera = front

    self.backInput = backInput
    self.selfieInput = frontInput
    session?.addInput(backInput)
  }

  func setupBackCamera() -> AVCaptureDevice? {
    let session = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInTripleCamera, .builtInDualWideCamera, .builtInWideAngleCamera, .builtInDualCamera],
      mediaType: .video,
      position: .back
    )

    let device = session.devices.first
    try? device?.lockForConfiguration()
    setupExposureFocusWhiteBalance(device)
    device?.unlockForConfiguration()
    return device
  }

  func setupSelfieCamera() -> AVCaptureDevice? {
    let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    try? device?.lockForConfiguration()
    setupExposureFocusWhiteBalance(device)
    device?.unlockForConfiguration()
    return device
  }

  private func setupExposureFocusWhiteBalance(_ device: AVCaptureDevice?) {
    if device?.isFocusModeSupported(.continuousAutoFocus) == true {
      device?.focusMode = .continuousAutoFocus
    }
    if device?.isExposureModeSupported(.autoExpose) == true {
      device?.exposureMode = .autoExpose
    }
    if device?.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) == true {
      device?.whiteBalanceMode = .continuousAutoWhiteBalance
    }
  }

  func setupAVOutputs() {
    videoOutput = AVCaptureVideoDataOutput()
    videoOutput?.setSampleBufferDelegate(self, queue: videoOutputQueue)
    guard session?.canAddOutput(videoOutput!) == true else {
      fatalError("Cannot use camera outputs")
    }
    session?.addOutput(videoOutput!)
    videoOutput!.connections.first?.videoOrientation = .portrait
  }

}

// MARK: - 3 Pause and Restart Camera on Scene Change

extension MetalCameraVC {

  func monitorSceneChanges() {
    restartOnForegrounding = NotificationCenter
      .default
      .publisher(for: UIApplication.willEnterForegroundNotification)
      .sink { [weak self] _ in self?.start() }

    pauseOnBackgrounding = NotificationCenter
      .default
      .publisher(for: UIApplication.willResignActiveNotification)
      .sink { [weak self] _ in self?.pause() }
  }
}

// MARK: - Prevent Rotation (See DTS History)

extension MetalCameraVC {
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    .portrait
  }

  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }

  /// Deprecated in iOS 16, but appears to be some bugs without use.
  override var shouldAutorotate: Bool { false }
}

#endif
