class RPCollectionViewController < UICollectionViewController
  include Modules::UserHelper

  def prefersStatusBarHidden
    true
  end
end