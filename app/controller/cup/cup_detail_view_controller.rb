class CupDetailViewController < RPTableViewController
  attr_accessor :cup

  include Helper::TableVCHelper

  def initWithCup(cup)
    if init
      self.cup = cup
    end

    self
  end

  def viewDidLoad
    super

    @cached_images = {
      vehicles: {},
      characters: {},
      users: {}
    }

    self.title = "Cup Details"
    self.tableView.registerClass(CupDetailTableViewCell, forCellReuseIdentifier:"Cell")
  end

  def cup_members
    @cup_members ||= CupMember.where(:cup_id).eq(cup.id).order(:placement).all
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    cup_members.length
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
    cup_member = cup_members[indexPath.row]

    cell.placement_label.text = cup_member.placement.to_s
    cell.points_label.text = cup_member.points.to_s

    set_remote_image(cup_member.user, cup_member.user.avatar_url, cell.user_image_view)
    set_remote_image(cup_member.character, cup_member.character.avatar_url, cell.character_image_view) if cup_member.character.present?
    set_remote_image(cup_member.vehicle, cup_member.vehicle.image_url, cell.vehicle_image_view) if cup_member.vehicle.present?

    cell
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    50
  end
end