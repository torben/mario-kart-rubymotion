class UserDetailViewController < RPTableViewController
  attr_accessor :user
  attr_accessor :cups

  def viewDidLoad
    @cups = []

    self.title = "Die Tabelle"
    self.tableView.registerClass(UserCupDetailTableViewCell, forCellReuseIdentifier:"Cell")

    self.tableView.tableHeaderView = UserDetailView.alloc.initWithFrame([[0, 0], [self.tableView.width, 100]])
  end

  def user=(user)
    @user = user
    self.tableView.tableHeaderView.user = user

    Cup.fetch("#{User.url}/#{user.id}/cups") do |models|
      self.cups = models
      self.tableView.reloadData
    end
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    cups.length
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)

    cup = cups[indexPath.row]
    cup_member = CupMember.where(:cup_id).eq(cup.id).and(:user_id).eq(user.id).first

    cell.set_cup_member_and_cup(cup_member, cup) if user.present?

    cell
  end
end