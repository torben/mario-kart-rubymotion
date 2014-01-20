class FinishCupViewController < RPTableViewController
  attr_reader :cup
  attr_accessor :saved_item_count

  def viewDidLoad
    self.title = "Cup Auswerten"
    self.tableView.registerClass(FinishTableViewCell, forCellReuseIdentifier:"Cell")

    nextButton = UIBarButtonItem.alloc.initWithTitle("Fertig", style: UIBarButtonItemStylePlain, target:self, action:"close_cup")
    self.navigationItem.rightBarButtonItem = nextButton
  end

  def cup=(cup)
    @cup = cup

    tableView.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    return 0 if cup.blank?

    section_count
  end

  def section_count
    cup.accepted_members.try(:length) || 0
  end

  def row_count
    2
  end

  def tableView(tableView, numberOfRowsInSection:section)
    row_count
  end

  def tableView(tableView, titleForHeaderInSection:section)
    cup_member = cup.accepted_members[section]

    cup_member.user.nickname
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cup_member = cup.accepted_members[indexPath.section]

    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    cell.input_field.delegate = self
    cell.input_field.indexPath = indexPath

    case indexPath.row
    when 0
      cell.textLabel.text = "Position"
      cell.input_field.text = (cup_member.placement || "??").to_s
    when 1
      cell.textLabel.text = "Punkte"
      cell.input_field.text = (cup_member.points || "??").to_s
    end

    cell.selectionStyle = UITableViewCellSelectionStyleNone
    # cell.user = user
    # cell.cellSelection = UIColor.greenColor
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return
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

  # Input delegates
  def textField(textField, shouldChangeCharactersInRange:range, replacementString:string)
    value = textField.text.stringByReplacingCharactersInRange(range, withString:string)

    if value.to_s.length <= 3
      #textField.text = value

      cup_member = cup.accepted_members[textField.indexPath.section]
      case textField.indexPath.row
      when 0
        cup_member.placement = value
      when 1
        cup_member.points = value
      end
    end
  end

  def textFieldShouldReturn(textField)
    section, row = [textField.indexPath.section, textField.indexPath.row]

    if section == section_count - 1 && row == row_count - 1
      textField.resignFirstResponder
    else
      next_row = row + 1
      next_section = section
      if next_row == row_count
        next_row = 0
        next_section += 1
      end

      cell = tableView.cellForRowAtIndexPath(NSIndexPath.indexPathForRow(next_row, inSection:next_section))
      if cell
        cell.input_field.becomeFirstResponder
      end
    end

    return false
  end

  def close_cup
    placements = []
    for cup_member in cup.accepted_members
      if cup_member.points.blank? || cup_member.placement.blank?
        App.alert "Bitte alle Fahrer ausfüllen"
        return
      elsif placements.include?(cup_member.placement)
        App.alert "Ein Platz kann nur einmal belegt werden..."
        return
      end

      placements.push cup_member.placement
    end

    LoadingView.show

    self.saved_item_count = 0
    cup.accepted_members.each do |cup_member|
      cup_member.save_remote(params) do
        self.saved_item_count += 1

        if saved_item_count == cup.accepted_members.length
          update_cup_and_redirect
        end
      end
    end
  end

  def update_cup_and_redirect
    winner = CupMember.where(:cup_id).eq(cup.id).and(:state).eq("accepted").order(:placement).first
    cup.winning_user_id = winner.user.id

    cup.save_remote(params) do
      LoadingView.hide

      navigationController.popToRootViewControllerAnimated true
    end
  end

  def params
    @params ||= {
      params: {
        api_key: User.current_user.api_key
      }
    }
  end
end