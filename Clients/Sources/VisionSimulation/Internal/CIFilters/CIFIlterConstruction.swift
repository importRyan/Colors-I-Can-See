// Copyright 2022 by Ryan Ferrell. @importRyan

import Foundation
import CoreImage
import ColorVision

extension CIFilter {
  convenience init?(vision: VisionType) {
    self.init(name: vision.ciFilterConstructorName)
  }
}

/// [Citation](https://www.inf.ufrgs.br/~oliveira/pubs_files/CVD_Simulation/CVD_Simulation.html)
class MachadoFilterVendor: NSObject, CIFilterConstructor {

  static func registerFilters() {
    let classAttributes = [kCIAttributeFilterCategories: ["CustomFilters"]]
    VisionType
      .allCases
      .forEach { vision in
        switch vision {
        case .typical:
          return
        case .monochromat:
          MonochromatFilter
            .registerName(
              vision.ciFilterConstructorName,
              constructor: MachadoFilterVendor(),
              classAttributes: classAttributes
            )
        default:
          MachadoFilter
            .registerName(
              vision.ciFilterConstructorName,
              constructor: MachadoFilterVendor(),
              classAttributes: classAttributes
            )
        }
      }
  }

  func filter(withName name: String) -> CIFilter? {
    var matrix = [CGFloat]()

    switch VisionType(ciFilterConstructorName: name) {
    case .typical: return nil

    case .monochromat:
      return MonochromatFilter(
        multiplier: .init(x: 0.2126, y: 0.7152, z: 0.0722)
      )

    case .deutan:
      matrix = [
        0.367322, 0.280085, -0.011820,
        0.860646, 0.672501, 0.042940,
        -0.227968, 0.047413, 0.968881
      ]

    case .protan:
      matrix = [
        0.152286, 0.114503, -0.003882,
        1.052583, 0.786281, -0.048116,
        -0.204868, 0.099216, 1.051998
      ]

    case .tritan:
      matrix = [
        1.255528, -0.078411, 0.004733,
        -0.076749, 0.930809, 0.691367,
        -0.178779, 0.147602, 0.303900
      ]

    }

    return MachadoFilter(matrix3x3: matrix)
  }
}

extension VisionType {

  /// Convenience for working CIFilterConstructor's stringly typed filter creation method: 'func filter(withName name: String) -> CIFilter?'
  fileprivate init(ciFilterConstructorName string: String) {
    self = VisionType.allCases
      .first { $0.ciFilterConstructorName == string }
    ?? .typical
  }

  /// Convenience for working CIFilterConstructor's stringly typed filter creation method: 'func filter(withName name: String) -> CIFilter?'
  fileprivate var ciFilterConstructorName: String {
    switch self {
    case .typical: return "Typical"
    case .deutan: return "Deutan"
    case .protan: return "Protan"
    case .tritan: return "Tritan"
    case .monochromat: return "Monochromat"
    }
  }
}
