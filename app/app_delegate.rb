TAUCHER_RED = UIColor.colorWithRed 0.8, green:0, blue:0.2, alpha:1.0

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationSlide)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = TAUCHER_RED
    @window.rootViewController = PanelsViewController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible()
    return true
  end
end
