class RPViewController < UIViewController
  include Modules::RemoteRequestHandler
  include Helper::Authentication

  def viewWillDisappear(animated)
    super
    handleViewWillDisappear
  end

  def prefersStatusBarHidden
    true
  end
end