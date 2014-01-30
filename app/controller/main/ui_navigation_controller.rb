class UINavigationController
  def prefersStatusBarHidden
    true
  end

  def viewDidLoad
    self.edgesForExtendedLayout = UIRectEdgeNone
  end
end