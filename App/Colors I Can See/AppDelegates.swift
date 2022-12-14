// Copyright 2022 by Ryan Ferrell. @importRyan

import Root
import SwiftUI
import TCA

#if os(iOS)

typealias AppDelegate = UIApplicationDelegateAdaptor<iOSAppDelegate>

class iOSAppDelegate: NSObject, UIApplicationDelegate {

  let store = StoreOf<Root>(
    initialState: .initialization,
    reducer: Root()
  )
  private lazy var viewStore = ViewStore(store.stateless)

  func application(
    _ app: UIApplication,
    didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]?
  ) -> Bool {
    viewStore.send(.initialization(.didFinishLaunching))
    return true
  }
}

#elseif os(macOS)

typealias AppDelegate = NSApplicationDelegateAdaptor<macOSAppDelegate>

class macOSAppDelegate: NSObject, NSApplicationDelegate {

  let store = StoreOf<Root>(
    initialState: .initialization,
    reducer: Root()
  )
  private lazy var viewStore = ViewStore(store.stateless)

  func applicationDidFinishLaunching(_ notification: Notification) {
    viewStore.send(.initialization(.didFinishLaunching))
  }
}

#endif
