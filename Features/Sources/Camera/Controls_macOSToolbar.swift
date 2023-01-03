// Copyright © 2023 by Ryan Ferrell. GitHub: importRyan

import ColorsUI
import TCA
import VisionType

struct Controls_macOSToolbar: ToolbarContent {

  let store: StoreOf<Camera>

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigation) {
      WithViewStore(store) { viewStore in
        PlayPauseButton(
          status: viewStore.status,
          didTap: { viewStore.send($0) }
        )
      }
    }
    ToolbarItemGroup(placement: .primaryAction) {
      SFSymbol.visionSimulation
        .accessibilityHidden(true)
        .foregroundStyle(.secondary)
      WithViewStore(store) { viewStore in
        SimulationPicker(
          simulation: viewStore.binding(\.$vision)
        )
        .help(.init("Camera.SelectVisionSimulationHelpTip", bundle: .module))
      }
    }
  }
}

struct PlayPauseButton: View {

  let status: Camera.State.StreamingStatus
  let didTap: (Camera.Action) -> Void

  var body: some View {
    switch status {
    case .paused, .resuming:
      CButton(
        action: { didTap(.resumeCamera) },
        symbol: .play
      )
      .help(.init("Camera.Resume", bundle: .module))
    case .streaming:
      CButton(
        action: { didTap(.pauseCamera) },
        symbol: .pause
      )
      .help(.init("Camera.Pause", bundle: .module))
    case .settingUp: ProgressView().controlSize(.small)
    case .needsSetup, .permissionsNotGranted: Color.clear
    }
  }
}
