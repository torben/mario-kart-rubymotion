class RPTableViewController < UITableViewController
  include Modules::UserHelper

  def viewDidLoad
    self.edgesForExtendedLayout = UIRectEdgeTop

    super
  end

  def prefersStatusBarHidden
    true
  end
end