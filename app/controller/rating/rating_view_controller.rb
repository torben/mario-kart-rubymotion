class RatingViewController < RPTableViewController
  attr_accessor :users

  def viewDidLoad
    @users = []

    self.title = "Die Tabelle"
    self.tableView.registerClass(RatingTableViewCell, forCellReuseIdentifier:"Cell")

    User.fetch(User.url) do |models|
      self.users = User.order{|one, two| two.points_per_race <=> one.points_per_race}.all
      self.tableView.reloadData
    end
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @users.length
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    cell.user = users[indexPath.row]

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    user_detail_vc = UserDetailViewController.new
    navigationController.pushViewController(user_detail_vc, animated: true)

    user_detail_vc.user = users[indexPath.row]
  end
end