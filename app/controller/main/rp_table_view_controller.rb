class RPTableViewController < UITableViewController
  include Helper::Authentication

  def viewDidLoad
    self.edgesForExtendedLayout = UIRectEdgeTop

    super
  end

  def prefersStatusBarHidden
    true
  end
end