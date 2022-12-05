// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture
import CameraCoordinator
import SwiftUI

@main
struct iOSApp: App {
  @UIApplicationDelegateAdaptor(iOSAppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      Root(store: appDelegate.store)
    }
  }
}

class iOSAppDelegate: NSObject, UIApplicationDelegate {
  fileprivate let store = Root.Store.initialState
  private lazy var viewStore = ViewStore(store.stateless)

  func application(
    _ app: UIApplication,
    didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
      
    return true
  }
}
