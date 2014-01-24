class UINavigationController
  def prefersStatusBarHidden
    true
  end

  def viewDidLoad
    self.edgesForExtendedLayout = UIRectEdgeTop
  end
end