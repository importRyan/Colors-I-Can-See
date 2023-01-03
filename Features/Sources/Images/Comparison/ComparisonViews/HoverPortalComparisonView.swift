// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI

struct HoverPortalComparisonView: View {

  init(
    baseImage: PlatformImage,
    maskedImage: PlatformImage,
    portalDiameter: CGFloat
  ) {
    self.baseImage = baseImage
    self.maskedImage = maskedImage
    _portalDiameter = .init(initialValue: portalDiameter)
    _lastPortalDiameter = .init(initialValue: portalDiameter)
  }

  private let baseImage: PlatformImage
  private let maskedImage: PlatformImage

  @State private var maskPosition: CGPoint? = nil
  @State private var isLocked = false
  @State private var portalDiameter: CGFloat
  @State private var lastPortalDiameter: CGFloat
  @GestureState private var isAdjustingPortalDiameter = false

  var body: some View {
    ZStack {
      baseImage.image
        .resizable()
        .scaledToFit()

      maskedImage.image
        .resizable()
        .scaledToFit()
        .mask { mask }
        .overlay { maskControlsOverlay }
    }
    .aspectRatio(baseImage.aspectRatio, contentMode: .fit)
    .clipped()
    .onTapGesture(perform: onTapGesture)
    .gesture(dragGesture())
    .onContinuousHover(perform: onContinuousHover)
  }
}

extension HoverPortalComparisonView {

  private func onTapGesture() {
    isLocked.toggle()
  }

  private func dragGesture() -> some Gesture {
    DragGesture()
      .updating($isAdjustingPortalDiameter) { _, state, _ in
        state = true
      }
      .onChanged { value in
        withAnimation(.interactiveSpring()) {
          portalDiameter = max(50, lastPortalDiameter + value.translation.height)
          maskPosition = value.location
        }
      }
      .onEnded { value in
        lastPortalDiameter = portalDiameter
      }
  }

  private func onContinuousHover(_ phase: HoverPhase) {
    if isLocked { return }
    withAnimation(.interactiveSpring()) {
      switch phase {
      case let .active(point):
        maskPosition = point
      case .ended: return
      }
    }
  }

  @ViewBuilder
  private var mask: some View {
    if let maskPosition {
      Circle()
        .fill(Color.black)
        .frame(width: portalDiameter, height: portalDiameter)
        .position(maskPosition)
    }
  }

  @ViewBuilder
  private var maskControlsOverlay: some View {
    if let maskPosition {
      ZStack(alignment: .bottomTrailing) {
        Circle()
          .stroke(Color.black, lineWidth: 1)

        if isAdjustingPortalDiameter {
          Image(systemName: "arrow.up.backward.and.arrow.down.forward")
            .font(.title)
            .foregroundColor(.black)
        }
      }
      .frame(width: portalDiameter, height: portalDiameter)
      .position(maskPosition)
    }
  }
}
