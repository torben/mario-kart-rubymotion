class CupViewController < RPTableViewController
  attr_reader :cup
  attr_accessor :timer

  def viewDidLoad
    super

    self.title = "Warte auf Fahrer"
    #self.view.backgroundColor = '#fff'.to_color

    self.tableView.registerClass(UITableViewCell, forCellReuseIdentifier:"Cell")

    nextButton = UIBarButtonItem.alloc.initWithTitle("Cup beenden", style: UIBarButtonItemStylePlain, target:self, action:"finish_cup")
    self.navigationItem.rightBarButtonItem = nextButton
  end

  def reload_cup
    cancel_timer

    self.timer = EM.add_timer 10.0 do
      LoadingView.show("Reloading")
      Cup.fetch("#{Cup.url}/#{cup.id}") do |l_cap|
        self.cup = Cup.find(l_cap.id)
        LoadingView.hide
      end
    end
  end

  def cancel_timer
    EM.cancel_timer(timer) if timer.present?
  end

  def viewWillAppear(animated)
    super(animated)

    reload_cup
  end

  def viewWillDisappear(animated)
    super

    cancel_timer
  end

  def viewDidLayoutSubviews
    super
  end

  def cup=(cup)
    @cup = cup
    self.tableView.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    return 0 if cup.blank?

    2
  end

  def tableView(tableView, numberOfRowsInSection:section)
    return 0 if cup.blank?

    case section
    when 0 then cup.accepted_members.length
    when 1 then cup.invited_members.length
    else 0
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    case section
    when 0 then "Eingecheckte Fahrer"
    when 1 then "Eingeladene Fahrer"
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    return cell if cup.blank?

    cell.contentView.subviews.each do |subview|
      subview.removeFromSuperview if subview.is_a?(UIButton)
    end

    case indexPath.section
    when 0
      accepted_player = cup.accepted_members[indexPath.row]
      cell.textLabel.text = accepted_player.user.nickname
      if accepted_player.user != user
        cell.contentView.addSubview remove_button indexPath.row
      end
    when 1
      cell.textLabel.text = cup.invited_members[indexPath.row].user.nickname
      if cup.accepted_members.length < 4
        cell.contentView.addSubview add_button indexPath.row
      end
    end
    cell.selectionStyle = UITableViewCellSelectionStyleNone

    # user = users[indexPath.row]

    # cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    # cell.user = user
    # #cell.cellSelection = UIColor.greenColor

    # if @selected_driver.include?(user)
    #   cell.accessoryType = UITableViewCellAccessoryCheckmark
    # end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # cell = tableView.cellForRowAtIndexPath indexPath
    # user = users[indexPath.row]

    # if @selected_driver.include?(user)
    #   cell.accessoryType = UITableViewCellAccessoryNone
    #   @selected_driver.delete user
    # else
    #   return if @selected_driver.length >= 3

    #   cell.accessoryType = UITableViewCellAccessoryCheckmark
    #   @selected_driver.push user
    # end

    tableView.deselectRowAtIndexPath(indexPath, animated:false)
  end

  def user
    @user ||= User.current_user
  end

  def remove_button(tag)
    btn = button_view('red'.to_color, 'white'.to_color, 'Entfernen')
    btn.tag = tag
    btn.addTarget(self, action:"remove_player:", forControlEvents:UIControlEventTouchUpInside)
    btn
  end

  def add_button(tag)
    btn = button_view('green'.to_color, 'white'.to_color, 'Hinzufügen')
    btn.tag = tag
    btn.addTarget(self, action:"add_player:", forControlEvents:UIControlEventTouchUpInside)
    btn
  end

  def button_view(background_color, font_color, title)
    padding = 10
    w = 100
    h = 20
    btn = UIButton.buttonWithType UIButtonTypeCustom
    btn.frame = [[view.width - padding - w, padding], [w, h]]
    btn.backgroundColor = background_color
    btn.setTitleColor(font_color, forState:UIControlStateNormal)
    btn.setTitle(title, forState:UIControlStateNormal)

    btn
  end

  def add_player(button)
    cup_member = cup.invited_members[button.tag]

    update_member_state(cup_member, "accepted")
  end

  def remove_player(button)
    cup_member = cup.accepted_members[button.tag]

    update_member_state(cup_member, "invited")
  end

  def update_member_state(cup_member, state)
    if cup_member.present?
      LoadingView.show

      cup_member.state = state
      cup_member.save_remote(params_for(user)) do
        LoadingView.hide
        tableView.reloadData
      end
    end
  end

  def finish_cup
    finish_cup_view_controller = FinishCupViewController.alloc.initWithStyle UITableViewStyleGrouped
    navigationController.pushViewController(finish_cup_view_controller, animated: true)
    finish_cup_view_controller.cup = cup
  end

  def params_for(user)
    {
      params: {
        api_key: user.api_key
      }
    }
  end
end