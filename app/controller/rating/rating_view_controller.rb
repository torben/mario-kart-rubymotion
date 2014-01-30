class RatingViewController < RPTableViewController
  attr_accessor :users

  def viewDidLoad
    @users = []
    @cached_images = []

    self.title = "The Charts"
    tableView.registerClass(RatingTableViewCell, forCellReuseIdentifier:"Cell")
    tableView.backgroundColor = '#F0F0F0'.to_color
  end

  def viewWillAppear(animated)
    super

    load_user
  end

  def load_user
    User.fetch(User.url) do |models|
      self.users = User.order{|one, two| two.points_per_race <=> one.points_per_race}.all
      tableView.reloadData
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
    user = users[indexPath.row]

    if @cached_images[user.id].present?
      cell.avatar_image_view.image = @cached_images[user.id]
    else
      cell.avatar_image_view.load_async_image user.avatar_url do |image|
        @cached_images[user.id] = image
        cell.avatar_image_view.image = image
      end
    end

    cell.text_label.text = user.nickname
    cell.count_label.text = user.points_per_race.to_s

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    user_detail_vc = UserDetailViewController.new
    navigationController.pushViewController(user_detail_vc, animated: true)

    user_detail_vc.user = users[indexPath.row]
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    50
  end
end