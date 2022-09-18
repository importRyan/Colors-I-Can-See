import ColorsUI
import Onboarding
import Camera

public struct RootView: View {
  public init() {
  }

  public var body: some View {
    NavigationView {
      CameraView()
//      OnboardingView()
//        .coordinateSpace(name: CoordinateSpace.rootScreen)
    }
  }
}

#if DEBUG
public struct Root_Previews: PreviewProvider {
  public static var previews: some View {
    RootView()
  }
}
#endif
