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

final class MTKViewHostController: VC {

  private let mtkView: MTKView
  private weak var metal: MetalAssetStore?

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
    mtkView.device = metal?.device
    mtkView.delegate = self
    mtkView.isPaused = true
    mtkView.enableSetNeedsDisplay = false
    mtkView.framebufferOnly = false
    self.view.addSubview(mtkView)
  }

#if os(macOS)
  override func loadView() {
    self.view = NSView()
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    registerForRendering()
    mtkView.translatesAutoresizingMaskIntoConstraints = false
    view.pinToBounds(mtkView)
  }

  override func viewDidDisappear() {
    unregisterForRendering()
  }

#elseif os(iOS)
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForRendering()
    mtkView.translatesAutoresizingMaskIntoConstraints = false
    view.pinToBounds(mtkView)
  }

  override func viewDidDisappear(_ animated: Bool) {
    unregisterForRendering()
  }
#endif
}

extension MTKViewHostController: MTKViewDelegate {

  func draw(in view: MTKView) {
    metal?.render(in: view)
  }

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
  }

  private func registerForRendering() {
    self.metal?.realtimeRenderDelegate = { [weak mtkView] in
      mtkView?.draw()
    }
  }

  private func unregisterForRendering() {
    self.metal?.realtimeRenderDelegate = .none
  }
}
