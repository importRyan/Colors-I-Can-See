// Copyright 2022 by Ryan Ferrell. @importRyan

import ColorsUI

struct TriggerButton: View {

  static let size = 85.0

  var body: some View {
    ZStack {
      Circle()
        .fill(.white.opacity(0.6))
      Circle()
        .stroke(.black, lineWidth: 2)
        .padding(8)
    }
    .frame(width: Self.size, height: Self.size)
  }
}
