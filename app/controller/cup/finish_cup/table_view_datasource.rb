module FinishCup
  module TableViewDatasource
    def numberOfSectionsInTableView(tableView)
      1
    end

    def row_count
      return 0 if cup.blank?

      cup_members.try(:length) || 0
    end

    def tableView(tableView, numberOfRowsInSection:section)
      row_count
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
      cup_member = cup_members[indexPath.row]

      cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
      cell.input_field.delegate = self
      cell.input_field.indexPath = indexPath

      if @cached_images[cup_member.id].present?
        cell.image_view.image = @cached_images[cup_member.id]
      else
        cell.image_view.load_async_image cup_member.user.avatar_url do |image|
          @cached_images[cup_member.id] = image
          cell.image_view.image = image
        end
      end
      cell.nickname_label.text = cup_member.user.nickname
      cell.input_field.text = (cup_member.points || "??").to_s
      cell.points_label.text = "Points"

      cell.selectionStyle = UITableViewCellSelectionStyleNone
      # cell.user = user
      # cell.cellSelection = UIColor.greenColor
      cell
    end

    def tableView(tableView, heightForRowAtIndexPath:indexPath)
      101
    end
  end
end