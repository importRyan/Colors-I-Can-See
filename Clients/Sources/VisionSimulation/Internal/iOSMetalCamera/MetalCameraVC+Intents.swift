//// Copyright 2022 by Ryan Ferrell. @importRyan
//#if canImport(UIKit)
//import Foundation
//
//// MARK: - Intents
//
//extension MTKViewController {
//
//  var exposureBiasLimits: (min: Float, max: Float) {
//    guard let device = currentDevice else { return (-6, -6) }
//    return (device.minExposureTargetBias, device.maxExposureTargetBias)
//  }
//
//  func updateExposureDelegate() {
//    let limits = exposureBiasLimits
//    DispatchQueue.main.async { [weak self] in
//      self?.exposureDelegate?.updateExposureLimits(min: limits.min, max: limits.max)
//    }
//  }
//
//  /// Relative position 0...1
//  func autoExpose(at point: CGPoint) {
//
//    videoOutputQueue.async { [weak self] in
//      guard let self = self,
//            self.currentDevice?.isExposureModeSupported(.autoExpose) == true
//      else { return }
//      self.isConfiguringCamera = true
//
//      do {
//        try self.currentDevice?.lockForConfiguration()
//
//        self.currentDevice?.setExposureTargetBias(0, completionHandler: nil)
//
//        if self.currentDevice?.isExposurePointOfInterestSupported == true {
//          self.currentDevice?.exposurePointOfInterest = point
//        }
//        self.currentDevice?.exposureMode = .autoExpose
//
//        self.currentDevice?.unlockForConfiguration()
//
//      } catch let error {
//        NSLog("Manual Exposure: \(error.localizedDescription)")
//      }
//      self.isConfiguringCamera = false
//      self.exposureDelegate?.updateExposureBias(bias: 0)
//    }
//  }
//
//  func setExposure(_ ev: Float) {
//    videoOutputQueue.async { [weak self] in
//      guard let self = self,
//            self.currentDevice?.isExposureModeSupported(.locked) == true
//      else { return }
//      self.isConfiguringCamera = true
//      let limits = self.exposureBiasLimits
//      let safeEV = min(limits.max, max(limits.min, ev))
//      do {
//        try self.currentDevice?.lockForConfiguration()
//        self.currentDevice?.setExposureTargetBias(safeEV, completionHandler: nil)
//        self.currentDevice?.unlockForConfiguration()
//
//      } catch let error {
//        NSLog("Manual Exposure: \(error.localizedDescription)")
//      }
//      self.isConfiguringCamera = false
//    }
//  }
//
//  func switchCameraInput(completion: @escaping () -> Void) {
//    guard !isConfiguringCamera,
//          let backInput = backInput,
//          let selfieInput = selfieInput
//    else { return }
//
//    isConfiguringCamera = true
//    session?.beginConfiguration()
//
//    if session?.inputs.first === self.backInput {
//      session?.removeInput(backInput)
//      guard session?.canAddInput(selfieInput)  == true else { return }
//      session?.addInput(selfieInput)
//      videoOutput?.connections.first?.isVideoMirrored = true
//    } else {
//      session?.removeInput(selfieInput)
//      guard session?.canAddInput(backInput) == true else { return }
//      session?.addInput(backInput)
//      videoOutput?.connections.first?.isVideoMirrored = false
//    }
//    videoOutput?.connections.first?.videoOrientation = .portrait
//    session?.commitConfiguration()
//    updateExposureDelegate()
//    isConfiguringCamera = false
//    completion()
//  }
//
//  func start() {
//    videoOutputQueue.async { [weak self] in
//      guard self?.session?.isRunning == false else { return }
//      self?.session?.startRunning()
//    }
//  }
//
//  func pause() {
//    videoOutputQueue.async {
//      guard self.session?.isRunning == true else { return }
//      self.session?.stopRunning()
//    }
//  }
//}
//
//#warning("TODO: Adapt from WCAG Shades")
//protocol ExposureDelegate: AnyObject {
//  func updateExposureLimits(min: Float, max: Float)
//  func updateExposureBias(bias: CGFloat)
//}
//#endif
