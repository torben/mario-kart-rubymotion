module FinishCup
  module TableViewDelegate
    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      return # TODO do we need an action?

      cell = tableView.cellForRowAtIndexPath indexPath
      user = users[indexPath.row]

      if @selected_driver.include?(user)
        cell.accessoryType = UITableViewCellAccessoryNone
        @selected_driver.delete user
      else
        # return if @selected_driver.length >= 3

        cell.accessoryType = UITableViewCellAccessoryCheckmark
        @selected_driver.push user
      end

      tableView.deselectRowAtIndexPath(indexPath, animated:false)
    end
  end
end