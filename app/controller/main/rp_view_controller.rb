class RPViewController < UIViewController
  include Modules::RemoteRequestHandler
  include Helper::Authentication
  include Helper::Animations

  def viewWillDisappear(animated)
    super
    handleViewWillDisappear
  end

  def prefersStatusBarHidden
    true
  end

  def viewDidLoad
    self.edgesForExtendedLayout = UIRectEdgeNone
  end
end