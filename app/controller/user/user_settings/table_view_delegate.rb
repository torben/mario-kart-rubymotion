module UserSettings
  module TableViewDelegate
    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      return open_action_sheet if indexPath.row == 0

      cell = tableView.cellForRowAtIndexPath indexPath

      vc = ModelSelectViewController.new

      vc.models = case indexPath.row
      when 1 then Character.order(:name).all
      when 2 then Vehicle.order(:name).all
      end

      navigationController.pushViewController(vc, animated: true)

      # tableView.deselectRowAtIndexPath(indexPath, animated:false)
    end
  end
end