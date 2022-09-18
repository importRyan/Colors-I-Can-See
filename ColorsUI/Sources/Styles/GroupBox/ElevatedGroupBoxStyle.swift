// Copyright 2022 by Ryan Ferrell. @importRyan

import SwiftUI

public struct ElevatedGroupBoxStyle: GroupBoxStyle {
  
  public func makeBody(configuration: Configuration) -> some View {
    VStack(alignment: .leading) {
      configuration.label
        .font(.callout.smallCaps())
        .padding(.bottom, Self.labelBottomPadding)

      VStack(alignment: .leading) {
        configuration.content
      }
        .padding(Self.interiorContentPadding)
        .background(.background, in: RoundedRectangle(cornerRadius: Self.cornerRadius))
    }
  }

  public static let interiorContentPadding = CGFloat(12)
  public static let cornerRadius = CGFloat(8)
  public static let labelBottomPadding = CGFloat(2)
}

extension GroupBoxStyle where Self == ElevatedGroupBoxStyle {
  public static var elevated: Self { Self.init() }
}
