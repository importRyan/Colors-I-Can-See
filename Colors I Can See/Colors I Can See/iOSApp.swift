// Copyright 2022 by Ryan Ferrell. @importRyan

import Root
import SwiftUI

@main
struct iOSApp: App {
  @UIApplicationDelegateAdaptor(iOSAppDelegate.self) private var appDelegate
  var body: some Scene {
    WindowGroup {
      RootView(
        store: appDelegate.store
      )
    }
  }
}

class iOSAppDelegate: NSObject, UIApplicationDelegate {
  fileprivate let store = RootStore()
}
