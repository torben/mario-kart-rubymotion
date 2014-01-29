class CupDetailTableViewCell < UITableViewCell
  attr_accessor :placement_label, :points_label, :user_image_view, :character_image_view, :vehicle_image_view

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      setup_view
    end

    self
  end

  def setup_view
    padding = 5
    x = 10
    y = padding
    w = 40
    h = 40

    @placement_label = PlacementLabel.alloc.initWithFrame [[x, y], [w, h]]
    x += w + padding

    @points_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]
    @points_label.textAlignment = UITextAlignmentCenter
    x += @points_label.width + padding

    @user_image_view = RPProfileImageView.alloc.initWithFrame [[x, y], [w, h]]
    x += @user_image_view.width + (padding * 3)

    @character_image_view = RPImageView.alloc.initWithFrame [[x, y], [w, h]]
    x += w + padding

    @vehicle_image_view = RPImageView.alloc.initWithFrame [[x, y], [76, h]]
    x += @vehicle_image_view.width + padding

    contentView.addSubviews @placement_label, @points_label, @user_image_view, @character_image_view, @vehicle_image_view
  end
end