// Copyright 2022 by Ryan Ferrell. @importRyan

#if canImport(UIKit)
import UIKit
import AVFoundation
import MetalKit
import Combine

#warning("TODO: Route errors properly")
final class MetalCameraVC: UIViewController {

  let mtkView = MTKView()
  private(set) var image = CIImage()
  private var scaleVideoToScreenEdges: CGAffineTransform = .identity

  weak var exposureDelegate: ExposureDelegate?

  var metalDevice:        MTLDevice
  var metalCommandQueue:  MTLCommandQueue
  var ciContext:          CIContext!
  weak var filters:       MetalController?

  var session:            AVCaptureSession?
  var videoOutput:        AVCaptureVideoDataOutput?
  var backInput:          AVCaptureInput?
  var backCamera:         AVCaptureDevice?
  var selfieInput:        AVCaptureInput?
  var selfieCamera:       AVCaptureDevice?
  let videoOutputQueue:   DispatchQueue
  var isConfiguringCamera = false

  var currentDevice: AVCaptureDevice? {
    session?.inputs.first === self.backInput ? self.backCamera : selfieCamera
  }

  var restartOnForegrounding: AnyCancellable?
  var pauseOnBackgrounding: AnyCancellable?

  init(
    device: MTLDevice,
    commandQueue: MTLCommandQueue,
    queue: DispatchQueue,
    controller: MetalController
  ) {
    self.metalDevice = device
    self.metalCommandQueue = commandQueue
    self.filters = controller
    self.videoOutputQueue = queue
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Camera feed processing

extension MetalCameraVC: AVCaptureVideoDataOutputSampleBufferDelegate {

  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    let image = CIImage(cvImageBuffer: buffer)
    guard let filtered = filter(image) else { return }
    self.image = filtered
    mtkView.draw()
  }

  func filter(_ image: CIImage) -> CIImage? {
    filters?.filter?.setValue(image, forKey: kCIInputImageKey)
    return filters?.filter?.outputImage ?? image
  }
}

extension MetalCameraVC : MTKViewDelegate {

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    transformVideoToScreenEdges(nil)
  }

  func draw(in mtkview: MTKView) {
    image = image.transformed(by: scaleVideoToScreenEdges)
    image = image.cropped(to: mtkview.drawableSize.zeroOriginRect())

    guard let buffer = metalCommandQueue.makeCommandBuffer(),
          let currentDrawable = mtkview.currentDrawable
    else { return }

    ciContext
      .render(
        image,
        to: currentDrawable.texture,
        commandBuffer: buffer,
        bounds: mtkview.drawableSize.zeroOriginRect(),
        colorSpace: CGColorSpaceCreateDeviceRGB()
      )

    buffer.present(currentDrawable)
    buffer.commit()
  }

  func transformVideoToScreenEdges(_ newSize: CGSize? = nil) {
    let videoSize = newSize ?? videoOutput?.outputSize ?? mtkView.drawableSize

    let ratioDisplayWidthToVideoWidth = mtkView.drawableSize.width / videoSize.width
    let ratioDisplayHeightToVideoHeight = mtkView.drawableSize.height / videoSize.height
    let largestRatio = max(ratioDisplayWidthToVideoWidth, ratioDisplayHeightToVideoHeight)

    scaleVideoToScreenEdges = CGAffineTransform(scaleX: largestRatio, y: largestRatio)
  }
}

extension AVCaptureVideoDataOutput {
  var outputSize: CGSize? {
    connections
      .first?
      .output?
      .outputRectConverted(
        fromMetadataOutputRect: .init(
          origin: .zero,
          size: .init(width: 1, height: 1)
        )
      )
      .size
  }
}
#endif
