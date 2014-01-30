class RPCollectionViewController < UICollectionViewController
  include Helper::Authentication
  include Helper::Animations
  include Modules::RemoteRequestHandler

  def viewWillDisappear(animated)
    super
    handleViewWillDisappear
  end

  def prefersStatusBarHidden
    true
  end
end