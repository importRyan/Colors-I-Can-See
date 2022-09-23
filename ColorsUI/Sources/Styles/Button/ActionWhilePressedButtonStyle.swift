// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct ActionWhilePressedButtonStyle: ButtonStyle {

  public init(isPressed: Binding<Bool>) {
    _isPressed = isPressed
  }

  @Binding
  private var isPressed: Bool

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .opacity(configuration.isPressed ? 0.6 : 1)
      .animation(.interactiveSpring(), value: configuration.isPressed)
      .onChange(of: configuration.isPressed) { newValue in
        let animation = newValue ? Animation.linear(duration: 0.14) : .easeIn(duration: 1.5)
        withAnimation(animation) {
          isPressed = newValue
        }
      }
  }
}
