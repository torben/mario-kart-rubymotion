class InviteCupViewController < RPTableViewController
  attr_accessor :cup, :users, :saved_item_count

  def viewDidLoad
    super

    @users = []
    @selected_driver = []

    self.title = "Kollege Invite"
    self.tableView.registerClass(InviteTableViewCell, forCellReuseIdentifier:"Cell")

    User.fetch(User.url) do |models|
      self.users = User.where(:id).ne(User.current_user.id).order(:nickname).all
      self.tableView.reloadData
    end

    next_button = UIBarButtonItem.alloc.initWithTitle("Weiter", style: UIBarButtonItemStylePlain, target:self, action:"do_invite")
    navigationItem.rightBarButtonItem = next_button
  end

  def cup=(cup)
    @cup = cup
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @users.length
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    user = users[indexPath.row]

    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    cell.user = user
    #cell.cellSelection = UIColor.greenColor

    if @selected_driver.include?(user)
      cell.accessoryType = UITableViewCellAccessoryCheckmark
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
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

  def do_invite
    return if @selected_driver.length == 0

    LoadingView.show

    params = {
      params: {
        api_key: User.current_user.api_key
      }
    }

    self.saved_item_count = 0
    @selected_driver.each do |user|
      cup_member = CupMember.new({ cup_id: cup.id, user_id: user.id, state: 'invited'})
      cup_member.save_remote(params) do
        self.saved_item_count += 1

        if saved_item_count == @selected_driver.length
          LoadingView.hide

          cup_view_controller = CupViewController.alloc.initWithStyle UITableViewStyleGrouped
          navigationController.pushViewController(cup_view_controller, animated: true)
          cup_view_controller.cup = cup
        end
      end
    end
  end
end