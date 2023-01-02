// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import SwiftUI

public struct CButton<Label: View>: View {

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    label: String
  ) where Label == Text {
    self.action = action
    self.role = role
    self.label = { Text(label) }
  }

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    label: Label
  ) {
    self.action = action
    self.role = role
    self.label = { label }
  }

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    label: @escaping () -> Label
  ) {
    self.action = action
    self.role = role
    self.label = label
  }

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    symbol: SFSymbol
  ) where Label == SFSymbol {
    self.action = action
    self.role = role
    self.label = { symbol }
  }

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    symbol: SFVariableSymbol
  ) where Label == SFVariableSymbol {
    self.action = action
    self.role = role
    self.label = { symbol }
  }

  private let action: () -> Void
  private let label: () -> Label
  private let role: ButtonRole?

  public var body: some View {
    Button(role: role, action: action, label: label)
  }
}
