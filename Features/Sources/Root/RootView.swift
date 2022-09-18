import ColorsUI
import Onboarding


public struct RootView: View {
  public init() {
  }

  public var body: some View {
    NavigationView {
      OnboardingView()
        .coordinateSpace(name: CoordinateSpace.rootScreen)
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
