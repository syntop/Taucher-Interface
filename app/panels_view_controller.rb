class PanelsViewController < UIViewController
  def loadView
    @panels = [
      'panel-01',
      'panel-02'
    ]
    @activePanel = 0
    @webviews = []
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    @scrollView = UIScrollView.alloc.initWithFrame([self.view.frame.origin, [self.view.frame.size.height, self.view.frame.size.width]])
    @scrollView.delegate = self
    @scrollView.clipsToBounds = true
    @scrollView.scrollEnabled = false
    @scrollView.pagingEnabled = true
    @scrollView.bounces = true
    @scrollView.setContentSize([self.view.bounds.size.height*@panels.length, self.view.bounds.size.width])
    @scrollView.backgroundColor = UIColor.whiteColor
    
    frame = @scrollView.frame
    
    @panels.each_index do |i|
      panel = @panels[i]
      padding = 10
      webview = UIWebView.alloc.initWithFrame([[frame.origin.x + frame.size.width*i + padding, frame.origin.y + padding],[frame.size.width-2*padding,frame.size.height-2*padding]])
      webview.scalesPageToFit = false
      webview.scrollView.scrollEnabled = false
      webview.scrollView.bounces = false
      webview.backgroundColor = UIColor.blackColor
      webview.delegate = self
      @scrollView.addSubview(webview)
      @webviews << webview
    end
    
    self.view.addSubview(@scrollView)
    
    button_size = 80
    
    @prev = UIButton.buttonWithType(UIButtonTypeCustom)
    @prev.setTitle('‹', forState:UIControlStateNormal)
    @prev.frame = [[0, frame.size.height-button_size], [button_size, button_size]]
    @prev.addTarget(self, action:'prevTapped', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@prev)
    
    @next = UIButton.buttonWithType(UIButtonTypeCustom)
    @next.setTitle('›', forState:UIControlStateNormal)
    @next.frame = [[frame.size.width-button_size, frame.size.height-button_size], [button_size, button_size]]
    @next.addTarget(self, action:'nextTapped', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@next)
  end
  
  def viewDidLoad
    @panels.each_index do |i|
      @webviews[i].loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource(@panels[i], ofType:'html'))))
    end
    return true
  end
  
  def shouldAutorotateToInterfaceOrientation(orientation)
    return [UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight].include?(orientation)
  end
  
  def prevTapped
    if @activePanel > 0
      @activePanel -= 1
      scrollToActivePanel()
    end
  end
  
  def nextTapped
    if @activePanel < @panels.length-1
      @activePanel += 1
      scrollToActivePanel()
    end
  end
  
  def scrollToActivePanel
    @scrollView.setContentOffset([@activePanel * @scrollView.frame.size.width, 0], animated:true)
  end
  
  def webView(webView, shouldStartLoadWithRequest:request, navigationType:navigationType)
    if request.URL.scheme == 'taucher'
      NSLog(request.URL.host)
      NSLog(request.URL.path[1,100])
      return false
    end
    return true
  end
  
  
end
