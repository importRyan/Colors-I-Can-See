// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import MetalKit.MTKView
import CoreMedia.CMSampleBuffer

extension MetalAssetStore {

  func getRealtimeTexture(fromCapturedFrame buffer: CMSampleBuffer) throws {
    guard let imageBuffer = buffer.imageBuffer else {
      throw MetalError.imageBufferNotAvailable
    }
    var cvMetalTexture: CVMetalTexture?
    let textureResult = CVMetalTextureCacheCreateTextureFromImage(
      kCFAllocatorDefault,
      self.realtimeTextureCache,
      imageBuffer,
      nil,
      .bgra8Unorm,
      CVPixelBufferGetWidth(imageBuffer),
      CVPixelBufferGetHeight(imageBuffer),
      0,
      &cvMetalTexture
    )
    guard
      textureResult == kCVReturnSuccess,
      let cvMetalTexture,
      let capturedTexture = CVMetalTextureGetTexture(cvMetalTexture) else {
      throw MetalError.imageBufferTextureUnavailable
    }
    self.realtimeInputTexture = capturedTexture
    self.realtimeRenderDelegate?()
  }

  func render(in mtkView: MTKView) {
    guard let inputTexture = realtimeInputTexture,
          let buffer = realtimeCommandQueue.makeCommandBuffer(),
          let drawable = mtkView.currentDrawable,
          let renderPass = mtkView.currentRenderPassDescriptor,
          let encoder = buffer.makeRenderCommandEncoder(descriptor: renderPass)
    else { return }

#if DEBUG
    encoder.pushDebugGroup("VisionSimulationRealTimeRender")
#endif

    var matrix = realtimeFilter.transform
    encoder.setFragmentBytes(
      &matrix,
      length: MemoryLayout.size(ofValue: matrix),
      index: 0
    )
    encoder.setRenderPipelineState(realtimeRenderPipelineState)
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
}
