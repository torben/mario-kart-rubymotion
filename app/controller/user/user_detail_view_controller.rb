class UserDetailViewController < RPTableViewController
  attr_accessor :user
  attr_accessor :cups

  def viewDidLoad
    @cups = []
    @cached_images = {
      vehicles: {},
      characters: {},
      users: {}
    }

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

    # cell.set_cup_member_and_cup(cup_member, cup) if user.present?

    cell.placement_label.layer.borderColor = user_background_color(cup, cup_member).CGColor
    cell.placement_label.text = cup_member.placement.to_s

    cell.points_label.text = cup_member.points.to_s

    set_images_for(cell, cup, cup_member)

    cell
  end

  def set_images_for(cell, cup, cup_member)
    if cup_member.character.present?
      set_remote_image(cup_member.character, cup_member.character.avatar_url, cell.character_image_view)
    end

    if cup_member.vehicle.present?
      set_remote_image(cup_member.vehicle, cup_member.vehicle.image_url, cell.vehicle_image_view)
    end

    cup_members = CupMember.where(:cup_id).eq(cup.id).and(:user_id).ne(current_user.id)
    CupMember.where(:cup_id).eq(cup.id).and(:user_id).ne(current_user.id).and(:points).ne(nil).order(:placement).all.each_with_index do |member, i|
      break if cell.drivers_image_views[i].blank?

      cell.drivers_image_views[i].hidden = false
      set_remote_image(member.user, member.user.avatar_url, cell.drivers_image_views[i])
    end
  end

  def set_remote_image(model, image_url, image_view)
    key = model.class.name.underscore.pluralize.to_sym
    if @cached_images[key][model.id].present?
      image_view.image = @cached_images[key][model.id]
    else
      image_view.load_async_image image_url do |image|
        @cached_images[key][model.id] = image
        image_view.image = image
      end
    end
  end

  def user_background_color(cup, cup_member)
    if cup_member.present? && cup.try(:winning_user_id) == cup_member.user.try(:id)
      'green'.to_color
    else
      'red'.to_color
    end
  end
end