module Invite
  module CollectionViewDelegate
    def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
      cell = collectionView.cellForItemAtIndexPath indexPath
      user = users[indexPath.row]

      if @selected_driver.include?(user)
        cell.selected = false
        @selected_driver.delete user
        @selected_rows.delete indexPath
      else
        cell.selected = true
        @selected_driver.push user
        @selected_rows.push indexPath
      end

      cell.update_cell_selection
      wubbel(cell.contentView)
      update_invite_button
    end

    def deselect_all_items
      for indexPath in @selected_rows
        cell = collectionView.cellForItemAtIndexPath indexPath
        cell.selected = false if cell.present?
        cell.update_cell_selection
      end

      @selected_driver = []
      @selected_rows = []
    end
  end
end