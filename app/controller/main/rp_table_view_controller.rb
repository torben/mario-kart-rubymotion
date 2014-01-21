class RPTableViewController < UITableViewController
  include Modules::UserHelper

  def prefersStatusBarHidden
    true
  end
end