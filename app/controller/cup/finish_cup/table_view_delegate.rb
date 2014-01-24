module FinishCup
  module TableViewDelegate
    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      cell = tableView.cellForRowAtIndexPath indexPath
      cup_member = cup_members[indexPath.row]

      return if cup_member.blank?
      return if cup_member.user.id == current_user.try(:id)
      return unless %w(invited accepted).include?(cup_member.try(:state))

      cancel_timer

      cup_member.state = cup_member.state == "invited" ? "accepted" : "invited"
      cup_member.save_remote(params) do |m|
        LoadingView.hide
        tableView.reloadData
        reload_cup
      end

      # tableView.deselectRowAtIndexPath(indexPath, animated:false)
    end
  end
end