// Copyright 2022 by Ryan Ferrell. @importRyan

import ComposableArchitecture
import Root
import SwiftUI

@main
struct iOSApp: App {
  @UIApplicationDelegateAdaptor(iOSAppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      Root.Screen(store: appDelegate.store)
    }
  }
}

class iOSAppDelegate: NSObject, UIApplicationDelegate {
  fileprivate let store = StoreOf<Root>(
    initialState: .initialization,
    reducer: Root()
  )
  private lazy var viewStore = ViewStore(store.stateless)

  func application(
    _ app: UIApplication,
    didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    viewStore.send(.initialization(.didFinishLaunching))
    return true
  }
}
