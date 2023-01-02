// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Foundation
import Metal
import MetalColorVisionSimulation
import VisionType
import CoreVideo
import CoreMedia.CMSampleBuffer

final class MetalAssetStore {

  let device: MTLDevice
  let dispatchQueue: DispatchQueue
  let library: MetalColorVisionSimulationLibrary
  let computeCommandQueue: MTLCommandQueue

  let realtimeCommandQueue: MTLCommandQueue
  let realtimeRenderPipelineState: MTLRenderPipelineState
  var realtimeInputTexture: MTLTexture?
  let realtimeTextureCache: CVMetalTextureCache
  var realtimeRender: (() -> Void)? = nil

  var filter: VisionType

  init(
    initialSimulation: VisionType,
    queue: DispatchQueue
  ) throws {
    self.device = try CreateSystemDefaultDevice()
    self.library = try MetalColorVisionSimulationLibrary(device: device)
    self.computeCommandQueue = try device.makeCommandQueue()
    self.realtimeCommandQueue = try device.makeCommandQueue()
    self.dispatchQueue = queue
    self.filter = initialSimulation
    self.realtimeRenderPipelineState = try CreateRealTimePipelineState(device, library)
    self.realtimeTextureCache = try CreateRealTimeTextureCache(device)
  }
}

// MARK: - Real Time Simulation

extension MetalAssetStore {
  func getTexture(fromCapturedFrame buffer: CMSampleBuffer) throws {
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
    self.realtimeRender?()
  }
}

// MARK: - Helpers

fileprivate func CreateSystemDefaultDevice() throws -> MTLDevice {
  guard let device = MTLCreateSystemDefaultDevice() else {
    throw InitializationError.gpuUnavailable
  }
  return device
}

fileprivate extension MTLDevice {
  func makeCommandQueue() throws -> MTLCommandQueue {
    guard let queue = self.makeCommandQueue() else {
      throw InitializationError.gpuCommandsUnavailable
    }
    return queue
  }
}

fileprivate func CreateRealTimePipelineState(
  _ device: MTLDevice,
  _ library: MetalColorVisionSimulationLibrary
) throws -> MTLRenderPipelineState {
  let descriptor = MTLRenderPipelineDescriptor()
  descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
  descriptor.depthAttachmentPixelFormat = .invalid

  descriptor.vertexFunction = library.vertexFunction
  descriptor.fragmentFunction = library.fragmentFunction
  return try device.makeRenderPipelineState(descriptor: descriptor)
}

fileprivate func CreateRealTimeTextureCache(_ device: MTLDevice) throws -> CVMetalTextureCache {
  var cache: CVMetalTextureCache!
  let cacheResult = CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &cache)
  guard cacheResult == kCVReturnSuccess else {
    throw MetalError.textureCacheCreationFailed
  }
  return cache
}
