module UserSettings
  module TableViewDatasource
    def numberOfSectionsInTableView(tableView)
      1
    end

    def tableView(tableView, numberOfRowsInSection:section)
      3
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
      cell_identifier = cell_identifier_for(indexPath)
      cell = tableView.dequeueReusableCellWithIdentifier(cell_identifier, forIndexPath:indexPath)
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      case indexPath.row
      when 0
        cell.input_field.delegate = self
        cell.input_field.text = current_user.nickname
        if @avatar.present?
          cell.image_view.image = @avatar
        else
          cell.image_view.load_async_image current_user.avatar_url
        end

        cell.image_view.when_tapped &Proc.new {
          open_action_sheet
        }.weak!
      when 1
        character = Character.find(current_user.last_character_id)

        cell.label_field.text = character.try :name
        cell.image_view.load_async_image character.avatar_url if character.present?
      when 2
        vehicle = Vehicle.find(current_user.last_vehicle_id)

        cell.label_field.text = vehicle.try :name
        cell.image_view.load_async_image vehicle.image_url if vehicle.present?
      end

      cell
    end

    def tableView(tableView, heightForRowAtIndexPath:indexPath)
      101
    end

    def cell_identifier_for(indexPath)
      case indexPath.row
      when 0 then "UserCell"
      else "ModelCell"
      end
    end
  end
end