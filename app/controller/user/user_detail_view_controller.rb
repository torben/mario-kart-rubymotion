class UserDetailViewController < RPTableViewController
  attr_accessor :user
  attr_accessor :cups

  include Helper::TableVCHelper

  def viewDidLoad
    @cups = []
    @cached_images = {
      vehicles: {},
      characters: {},
      users: {}
    }

    self.title = "All Of Me"
    tableView.registerClass(UserCupDetailTableViewCell, forCellReuseIdentifier:"Cell")

    tableView.tableHeaderView = UserDetailView.alloc.initWithFrame([[0, 0], [self.tableView.width, 110]])
    tableView.backgroundColor = '#F0F0F0'.to_color
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

    # cell.set_cup_member_and_cup(cup_member, cup) if user.present?

    cell.placement_label.text = cup_member.placement.to_s

    cell.points_label.text = cup_member.points.to_s

    cup_members = CupMember.where(:cup_id).eq(cup.id).and(:user_id).ne(current_user.id)

    cell.drivers_image_views.each do |c|
      c.hidden = true
    end

    CupMember.where(:cup_id).eq(cup.id).and(:points).ne(nil).order(:placement).all.each_with_index do |member, i|
      break if cell.drivers_image_views[i].blank?

      cell.drivers_image_views[i].hidden = false
      set_remote_image(member.user, member.user.avatar_url, cell.drivers_image_views[i])
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    cup = cups[indexPath.row]

    cup_detail_view_controller = CupDetailViewController.alloc.initWithCup cup
    navigationController.pushViewController(cup_detail_view_controller, animated: true)
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    50
  end
end