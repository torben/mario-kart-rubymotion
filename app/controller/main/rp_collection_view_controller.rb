class RPCollectionViewController < UICollectionViewController
  include Helper::Authentication

  def prefersStatusBarHidden
    true
  end
end