// Copyright 2022 by Ryan Ferrell. @importRyan

import CoreImage

class MachadoFilter: CIFilter {

  @objc dynamic var inputImage: CIImage?
  @objc dynamic var matrixHalf3x3: CIVector

  init(matrix3x3: [CGFloat]) {
    self.matrixHalf3x3 = .init(values: matrix3x3, count: 9)
    super.init()
  }

  required init?(coder: NSCoder) { fatalError() }

  private lazy var kernel =  {
    do {
      return try CIColorKernel(functionName: "monochrome")
    } catch {
      #warning("TODO: Check compilation settings for metallib. Error: This library format is not supported on this platform (or was built with an old version of the tools)")
      fatalError(error.localizedDescription)
    }
  }()

  override var description: String {
    return("Color blindness simulation (Machado et al.)")
  }

  override var attributes: [String : Any] {
    return [
      kCIAttributeFilterDisplayName: "Machado",
      "inputImage": inputImageAttributes(),
    ]
  }

  override var outputImage: CIImage? {
    guard let inputImage else {
      return nil
    }
    return kernel.apply(
      extent: inputImage.extent,
      roiCallback: { (_, _) in .null },
      arguments: [
        CISampler(image: inputImage),
        matrixHalf3x3,
      ]
    )
  }
}

class MonochromatFilter: CIFilter {

  @objc dynamic var inputImage: CIImage?
  @objc dynamic let multiplierHalf3: CIVector = .init(x: 0.2126, y: 0.7152, z: 0.0722)

  convenience override init() {
    self.init()
  }

  required init?(coder: NSCoder) { fatalError() }

  private lazy var kernel = {
    do {
      return try CIColorKernel(functionName: "monochrome")
    } catch {
      fatalError(error.localizedDescription)
    }
  }()

  override var description: String {
    return("Monochromacy simulation (not peer-reviewed)")
  }

  override var attributes: [String : Any] {
    return [
      kCIAttributeFilterDisplayName: "Monochromacy",
      "inputImage": inputImageAttributes(),
    ]
  }

  override var outputImage: CIImage? {
    guard let inputImage else {
      return nil
    }
    return kernel.apply(
      extent: inputImage.extent,
      roiCallback: { (_, _) in .null },
      arguments: [
        CISampler(image: inputImage),
        multiplierHalf3,
      ])
  }
}

extension URL {
  fileprivate static let machadoFilters = Bundle.module.url(
    forResource: "Machado",
    withExtension: "metallib",
    subdirectory: "Metal"
  )!
}

fileprivate func inputImageAttributes() -> [String: Any] {
  [
    kCIAttributeIdentity: 0,
    kCIAttributeClass: "CIImage",
    kCIAttributeDisplayName: "Image",
    kCIAttributeType: kCIAttributeTypeImage
  ]
}

extension CIColorKernel {
  convenience init(functionName: String) throws {
    #if DEBUG
    let device = MTLCreateSystemDefaultDevice()!
    let library = try device.makeLibrary(URL: .machadoFilters)
    print(library.functionNames)
    #endif
    let data = try Data(contentsOf: .machadoFilters)
    try self.init(
      functionName: functionName,
      fromMetalLibraryData: data,
      outputPixelFormat: CIFormat.RGBAh
    )
  }
}
