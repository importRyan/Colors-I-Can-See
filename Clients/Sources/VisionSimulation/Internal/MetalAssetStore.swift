// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Foundation
import MetalKit
import MetalColorVisionSimulation
import VisionType

final class MetalAssetStore {

  let device: MTLDevice
  let dispatchQueue: DispatchQueue
  let library: MetalColorVisionSimulationLibrary

  let computeCommandQueue: MTLCommandQueue
  let computePipelineState: MTLComputePipelineState
  let computeTextureLoader: MTKTextureLoader

  let realtimeCommandQueue: MTLCommandQueue
  let realtimeRenderPipelineState: MTLRenderPipelineState
  let realtimeTextureCache: CVMetalTextureCache
  var realtimeInputTexture: MTLTexture?
  var realtimeFilter: VisionType
  var realtimeRenderDelegate: (() -> Void)? = nil

  init(
    initialSimulation: VisionType,
    queue: DispatchQueue
  ) throws {
    self.device = try CreateSystemDefaultDevice()
    self.dispatchQueue = queue
    self.library = try MetalColorVisionSimulationLibrary(device: device)
    self.realtimeFilter = initialSimulation

    self.computeCommandQueue = try device.makeCommandQueue()
    self.computeTextureLoader = MTKTextureLoader(device: device)
    self.computePipelineState = try device.makeComputePipelineState(function: library.computeFunction)

    self.realtimeCommandQueue = try device.makeCommandQueue()
    self.realtimeRenderPipelineState = try CreateRealTimePipelineState(device, library)
    self.realtimeTextureCache = try CreateRealTimeTextureCache(device)
  }
}

// MARK: - Init Helpers

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
