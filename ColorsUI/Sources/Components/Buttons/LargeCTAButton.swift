// Copyright 2022 by Ryan Ferrell. @importRyan

public struct LargeCTAButton<Label: View, S: PrimitiveButtonStyle>: View {

  public init(
    _ label: String,
    role: ButtonRole? = nil,
    action: @escaping () -> Void
  ) where Label == Text, S == BorderedProminentButtonStyle {
    self.action = action
    self.label = { Text(label) }
    self.role = role
    self.style = .init()
  }

  public init(
    _ label: String,
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    style: S
  ) where Label == Text {
    self.action = action
    self.label = { Text(label) }
    self.role = role
    self.style = style
  }

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    label: @escaping () -> Label,
    style: S
  ) {
    self.action = action
    self.label = label
    self.role = role
    self.style = style
  }

  public init(
    role: ButtonRole? = nil,
    action: @escaping () -> Void,
    label: @escaping () -> Label
  ) where S == BorderedProminentButtonStyle {
    self.action = action
    self.label = label
    self.role = role
    self.style = .init()
  }

  private let action: () -> Void
  private let label: () -> Label
  private let role: ButtonRole?
  private let style: S

  public var body: some View {
    Button(
      role: role,
      action: action,
      label: {
        label()
          .font(.title3.weight(.medium))
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
      }
    )
    .buttonStyle(style)
  }
}
