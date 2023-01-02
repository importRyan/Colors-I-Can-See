// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Foundation
import MetalKit
import MetalColorVisionSimulation
import VisionType
import class CoreImage.CIImage

extension MetalAssetStore {

  func computeSimulations(for cgImage: CGImage) async throws -> [VisionType: CIImage] {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      self?.dispatchQueue.async { [weak self] in
        guard let self else { return }
        do {
          let output = try self.syncComputeSimulations(for: cgImage)
          continuation.resume(with: .success(output))
        } catch {
          continuation.resume(with: .failure(error))
        }
      }
    }
  }

  private func syncComputeSimulations(for cgImage: CGImage) throws -> [VisionType: CIImage] {
    guard let buffer = self.computeCommandQueue.makeCommandBuffer() else {
      throw MetalError.computeBufferNotAvailable
    }

    // Prepare input and output textures
    let inputTexture = try self.computeTextureLoader.newTexture(cgImage: cgImage)
    let threadCount = 16
    let threadgroupsPerGrid = MTLSize(
      width: inputTexture.width / threadCount + 1,
      height: inputTexture.height / threadCount + 1,
      depth: 1
    )
    let threadsPerThreadGroup = MTLSize(
      width: threadCount,
      height: threadCount,
      depth: 1
    )
    let outputDescriptor = MTLTextureDescriptor.texture2DDescriptor(
      pixelFormat: .rgba8Unorm_srgb,
      width: inputTexture.width,
      height: inputTexture.height,
      mipmapped: false
    )
    outputDescriptor.usage.insert(.shaderWrite)
    let outputTextures = try VisionType
      .allColorBlindCases
      .compactMap { vision -> (vision: VisionType, texture: MTLTexture) in
        guard let texture = device.makeTexture(descriptor: outputDescriptor) else {
          throw MetalError.computeTextureCreationFailed
        }
        return (vision, texture)
      }

    // Enqueue commands
    outputTextures.forEach { vision, outputTexture in
      var matrix = vision.transform
      let encoder = buffer.makeComputeCommandEncoder()!
      encoder.setBytes(
        &matrix,
        length: MemoryLayout.size(ofValue: matrix),
        index: 0
      )
      encoder.setComputePipelineState(self.computePipelineState)
      encoder.setTexture(inputTexture, index: 0)
      encoder.setTexture(outputTexture, index: 1)
      encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadGroup)
      encoder.endEncoding()
    }
    buffer.commit()

    // Emit in top-up CIImage format
    buffer.waitUntilCompleted()
    return outputTextures
      .reduce(into: [VisionType: CIImage]()) { result, output in
        let outputImage = CIImage(
          mtlTexture: output.texture,
          options: [CIImageOption.colorSpace : CGColorSpace.eSRGB]
        )
        if let outputImage {
          result[output.vision] = outputImage.oriented(.downMirrored)
        }
      }
  }
}

extension CGColorSpace {
  fileprivate static let eSRGB = CGColorSpace(name: CGColorSpace.extendedSRGB)!
}
