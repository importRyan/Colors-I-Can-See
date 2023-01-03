// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import Metal

public final class MetalColorVisionSimulationLibrary {

  public let library: MTLLibrary
  public let computeFunction: MTLFunction
  public let fragmentFunction: MTLFunction
  public let vertexFunction: MTLFunction

  public init(device: MTLDevice) throws {
    self.library = try device.makeDefaultLibrary(bundle: .module)
    guard let computeFunction = library.makeFunction(name: "computeTransform") else {
      throw MTLLibraryError(.functionNotFound)
    }
    guard let fragmentFunction = library.makeFunction(name: "renderTransform") else {
      throw MTLLibraryError(.functionNotFound)
    }
    guard let vertexFunction = library.makeFunction(name: "orientPixels") else {
      throw MTLLibraryError(.functionNotFound)
    }
    self.computeFunction = computeFunction
    self.fragmentFunction = fragmentFunction
    self.vertexFunction = vertexFunction
  }
}
