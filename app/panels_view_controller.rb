class PanelsViewController < UIViewController
  def loadView
    @panels = [
      'panel-01',
      'panel-02',
      'panel-03',
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
      webview.backgroundColor = UIColor.whiteColor
      webview.setAlpha(0)
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
    
    @osc = OSCConnection.alloc.init
    @osc.delegate = self
    @oscErrorPtr = Pointer.new(:object)
    @osc.connectToHost('10.0.1.206', port:11000, protocol:0, error:@oscErrorPtr)
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
      json = request.URL.path[1..-1]
      data = json.dataUsingEncoding(1) # NSUTF8StringEncoding?
      jsonError = Pointer.new(:object)
      values = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingMutableContainers, error:jsonError)
      
      message = OSCMutableMessage.alloc.init
      message.address = "/#{request.URL.host}"
      
      values.each do |value|
        case value['type']
          when 'string'
            message.addString value['value']
          when 'int'
            message.addInt value['value']
          when 'float'
            message.addFloat value['value']
          when 'bool'
            message.addBool value['value']
          when 'blob'
            message.addBlob value['value']
          when 'timetag'
            message.addTimeTag value['value']
          when 'impulse'
            message.addImpulse
          when 'null'
            message.addNull
        end
      end
      
      @osc.sendPacket(message)
      return false
    end
    return true
  end
  
  def webViewDidFinishLoad(webView)
    webView.alpha = 0
    UIView.beginAnimations(nil, context:nil)
    UIView.setAnimationDuration(1)
    webView.setAlpha(1)
    UIView.commitAnimations()
  end
  
  
end
