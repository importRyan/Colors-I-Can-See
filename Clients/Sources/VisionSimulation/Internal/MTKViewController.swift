// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorBlindnessTransforms
import MetalKit

#if canImport(AppKit)
import AppKit
typealias VC = NSViewController
#elseif canImport(UIKit)
import UIKit
typealias VC = UIViewController
#endif

final class MTKViewController: VC {

  private let mtkView: MTKView
  private let metal: MetalAssetStore

  init(metal: MetalAssetStore) {
    self.metal = metal
    self.mtkView = .init()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    mtkView.device = metal.device
    mtkView.delegate = self
    mtkView.isPaused = true
    mtkView.enableSetNeedsDisplay = false
    mtkView.framebufferOnly = false
    self.view.addSubview(mtkView)
    self.metal.realtimeRender = {
      self.mtkView.draw()
    }
  }

#if os(macOS)
  override func loadView() {
    self.view = NSView()
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    mtkView.autoresizingMask = [.width, .height]
    view.autoresizingMask = [.width, .height]
  }

#elseif os(iOS)
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mtkView.translatesAutoresizingMaskIntoConstraints = false
    view.pinToBounds(mtkView)
  }
#endif
}

// MARK: - Rendering

extension MTKViewController: MTKViewDelegate {

  func draw(in view: MTKView) {
    guard let inputTexture = metal.realtimeInputTexture,
          let buffer = metal.realtimeCommandQueue.makeCommandBuffer(),
          let drawable = mtkView.currentDrawable,
          let renderPass = mtkView.currentRenderPassDescriptor,
          let encoder = buffer.makeRenderCommandEncoder(descriptor: renderPass)
    else { return }

#if DEBUG
    encoder.pushDebugGroup("MetalCameraVC")
#endif

    var matrix = metal.filter.transform
    encoder.setFragmentBytes(
      &matrix,
      length: MemoryLayout.size(ofValue: matrix),
      index: 0
    )
    encoder.setRenderPipelineState(metal.realtimeRenderPipelineState)
    encoder.setFragmentTexture(inputTexture, index: 0)
    encoder.drawPrimitives(
      type: .triangleStrip,
      vertexStart: 0,
      vertexCount: 4,
      instanceCount: 1
    )

#if DEBUG
    encoder.popDebugGroup()
#endif

    encoder.endEncoding()
    buffer.present(drawable)
    buffer.commit()
  }

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
  }
}
