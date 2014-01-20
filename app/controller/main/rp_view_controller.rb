class RPViewController < UIViewController
  include Modules::RemoteRequestHandler

  def viewWillDisappear(animated)
    super
    handleViewWillDisappear
  end

  def prefersStatusBarHidden
    true
  end
end