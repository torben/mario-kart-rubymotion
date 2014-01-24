class RPTableViewController < UITableViewController
  include Helper::Authentication
  include Modules::RemoteRequestHandler

  def viewDidLoad
    self.edgesForExtendedLayout = UIRectEdgeTop

    super
  end

  def viewWillDisappear(animated)
    super
    handleViewWillDisappear
  end

  def prefersStatusBarHidden
    true
  end
end