class UserCupDetailTableViewCell < UITableViewCell
  attr_accessor :cup_member, :cup

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super

    setup_view

    self
  end

  def setup_view
    self.userInteractionEnabled = false

    padding = 3
    x = 10
    y = padding
    w = 30
    h = 30

    @placement_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]
    x += w + padding

    @character_image_view = RPImageView.alloc.initWithFrame [[x, y], [w, h]]
    x += w + padding

    @vehicle_image_view = RPImageView.alloc.initWithFrame [[x, y], [58, h]]
    x += @vehicle_image_view.width + padding

    @points_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]

    addSubviews @character_image_view, @vehicle_image_view, @placement_label, @points_label
  end

  def configure_view
    self.contentView.backgroundColor = userBackgroundColor
    @placement_label.text = @cup_member.placement.to_s
    @character_image_view.load_async_image @cup_member.character.avatar_url if @cup_member.character.present?
    @vehicle_image_view.load_async_image @cup_member.vehicle.image_url if @cup_member.vehicle.present?
    @points_label.text = @cup_member.points.to_s
  end

  def userBackgroundColor
    if cup_member.present? && @cup.try(:winning_user_id) == cup_member.user.try(:id)
      'green'.to_color
    else
      'red'.to_color
    end
  end

  def set_cup_member_and_cup(cup_member, cup)
    @cup = cup
    @cup_member = cup_member

    configure_view
  end
end