class FinishCupViewController < RPTableViewController
  attr_reader :cup
  attr_accessor :saved_item_count, :timer

  def viewDidLoad
    @cached_images = {}
    self.title = "Fill in the results"
    tableView.registerClass(FinishTableViewCell, forCellReuseIdentifier:"Cell")

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    tableView.separatorColor = UIColor.clearColor
    tableView.backgroundColor = '#F0F0F0'.to_color

    # @start_button = RPButton.custom
    # @start_button.setTitle('Done', forState:UIControlStateNormal)
    # @start_button.setTitleColor('#fff'.to_color, forState:UIControlStateNormal)
    # @start_button.setBackgroundColor '#26A5EF'.to_color
    # @start_button.layer.cornerRadius = 5
    # @start_button.frame = [[10, tableView.height - 70 - navigationController.navigationBar.height], [300, 60]]
    # update_start_button

    # @start_button.addTarget(self, action:"close_cup", forControlEvents:UIControlEventTouchUpInside)

    # tableView.addSubview @start_button

    gesture = UILongPressGestureRecognizer.alloc.initWithTarget(self, action:"start_deleting:")
    tableView.addGestureRecognizer(gesture)

    close_button = UIBarButtonItem.alloc.initWithTitle("Done", style: UIBarButtonItemStylePlain, target:self, action:"close_cup")
    navigationItem.rightBarButtonItem = close_button
  end

  def start_deleting(gesture)
    touchPoint = gesture.locationInView(tableView)
    indexPath = tableView.indexPathForRowAtPoint(touchPoint)

    return if indexPath.blank?
    return if cup_members[indexPath.row].blank? || cup_members[indexPath.row].user.id == current_user.id

    cell = tableView.cellForRowAtIndexPath indexPath

    case gesture.state
    when UIGestureRecognizerStateBegan then start_delete cell
    when UIGestureRecognizerStateEnded then cancel_delete cell
    end
  end

  def start_delete(cell)
    return if cell.alpha == 0
    cancel_timer

    UIView.animateWithDuration(0.6, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      cell.alpha = 0.01
    }, completion: lambda { |completed|
      if completed
        cell.alpha = 0
        finish_delete(cell)
      end
    })
  end

  def cancel_delete(cell)
    return if cell.alpha == 0

    UIView.animateWithDuration(0.6, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        cell.alpha = 1
      }, completion: lambda { |finished|
        reload_cup if finished
      })
  end

  def finish_delete(cell)
    if cell.alpha == 0.0
      indexPath = tableView.indexPathForCell(cell)
      return if indexPath.blank?

      LoadingView.show("Deleting")
      cup_members[indexPath.row].destroy_remote(params) do
        LoadingView.hide
        tableView.reloadData
        reload_cup
      end
    else
      cancel_delete
    end
  end

  def viewWillAppear(animated)
    super(animated)

    reload_cup
  end

  def viewWillDisappear(animated)
    super

    cancel_timer
  end

  def cup=(cup)
    @cup = cup

    reload
  end

  def reload
    tableView.reloadData
    # update_start_button

    reload_cup
  end

  def reload_cup
    return if cup.blank?
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

  # def update_start_button
  #   @start_button.hidden = cup.blank?
  # end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def cup_members
    cup_members = active_cup_members
    cup_members << cup.invited_members
    cup_members.flatten
  end

  def active_cup_members
    active_cup_members = [cup.hosting_member]
    active_cup_members << cup.accepted_members
    active_cup_members.flatten
  end

  def row_count
    return 0 if cup.blank?

    cup_members.try(:length) || 0
  end

  def tableView(tableView, numberOfRowsInSection:section)
    row_count
  end

  # def tableView(tableView, titleForHeaderInSection:section)
  #   cup_member = cup.cup_members[section]

  #   cup_member.user.nickname
  # end

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

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    101
  end

  # Input delegates
  def textFieldShouldBeginEditing(textField)
    cancel_timer
    true
  end

  def textField(textField, shouldChangeCharactersInRange:range, replacementString:string)
    value = textField.text.stringByReplacingCharactersInRange(range, withString:string)

    if value.to_s.length <= 3
      #textField.text = value

      cup_member = cup_members[textField.indexPath.row]
      cup_member.points = value
    end
  end

  def textFieldShouldReturn(textField)
    row = textField.indexPath.row

    if row == row_count - 1
      textField.resignFirstResponder
    else
      next_row = row + 1
      if next_row == row_count
        next_row = 0
      end

      cell = tableView.cellForRowAtIndexPath(NSIndexPath.indexPathForRow(next_row, inSection:0))
      cell.input_field.becomeFirstResponder if cell
    end

    return false
  end

  def close_cup
    placements = []
    for cup_member in active_cup_members
      if cup_member.points.blank?# || cup_member.placement.blank?
        App.alert "Please fill in the fields!"
        return
      # elsif placements.include?(cup_member.placement)
      #   App.alert "Ein Platz kann nur einmal belegt werden..."
      #   return
      end

      # placements.push cup_member.placement
    end

    LoadingView.show

    self.saved_item_count = 0
    cup_members.each do |cup_member|
      cup_member.save_remote(params) do
        self.saved_item_count += 1

        if saved_item_count == cup_members.length
          update_cup_and_redirect
        end
      end
    end
  end

  def update_cup_and_redirect
    winner = CupMember.where(:cup_id).eq(cup.id).and(:points).ne(nil).order{|one, two| two.points <=> one.points}.first
    cup.winning_user_id = winner.user.id

    cup.save_remote(params) do
      LoadingView.hide

      alert = App.alert("Thank You!")
      alert.delegate = self
    end
  end

  def alertView(alertView, clickedButtonAtIndex:index)
    menu_view_controller = App.window.rootViewController
    raise "Da ist was schief!" unless menu_view_controller.is_a?(MenuViewController)

    menu_view_controller.goto_vc_at_position(1, UIPageViewControllerNavigationDirectionForward, true)
    self.cup = nil
  end

  def params
    @params ||= {
      params: {
        api_key: User.current_user.api_key
      }
    }
  end
end