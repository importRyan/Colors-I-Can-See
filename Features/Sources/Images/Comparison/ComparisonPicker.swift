// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI

struct ComparisonPicker: View {
  @Binding var comparison: ComparisonStyle

  var body: some View {
    Picker("Comparison", selection: $comparison) {
      ForEach(ComparisonStyle.allCases) { style in
        Text(style.localizedName)
          .tag(style)
      }
    }
  }
}
