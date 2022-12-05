// Copyright 2022 by Ryan Ferrell. @importRyan

import Root
import SwiftUI

@main
struct MultiplatformApp: App {

  @AppDelegate private var delegate

  var body: some Scene {
    WindowGroup {
      Root.Screen(store: delegate.store)
    }
  }
}
