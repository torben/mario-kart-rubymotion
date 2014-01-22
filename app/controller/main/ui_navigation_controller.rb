class UINavigationController
  def prefersStatusBarHidden
    true
  end

  def viewDidLoad
    puts "RED".red
    self.edgesForExtendedLayout = UIRectEdgeTop
  end
end