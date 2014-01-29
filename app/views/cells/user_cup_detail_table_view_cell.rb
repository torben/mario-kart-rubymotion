class UserCupDetailTableViewCell < UITableViewCell
  attr_accessor :placement_label, :character_image_view, :vehicle_image_view, :points_label, :drivers_image_views

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      setup_view
    end

    self
  end

  def setup_view
    self.userInteractionEnabled = false
    self.drivers_image_views = []

    padding = 3
    x = 10
    y = padding
    w = 30
    h = 30

    @placement_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]
    @placement_label.layer.borderColor = '#D8D8D8'.to_color.CGColor
    @placement_label.layer.borderWidth = 3
    @placement_label.layer.cornerRadius = w / 2
    @placement_label.layer.masksToBounds = true
    @placement_label.textAlignment = UITextAlignmentCenter
    x += w + padding

    @character_image_view = RPImageView.alloc.initWithFrame [[x, y], [w, h]]
    x += w + padding

    @vehicle_image_view = RPImageView.alloc.initWithFrame [[x, y], [58, h]]
    x += @vehicle_image_view.width + padding

    @points_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]
    x += @points_label.width + padding

    contentView.addSubviews @character_image_view, @vehicle_image_view, @placement_label, @points_label

    for i in 0..2
      image_view = RPProfileImageView.alloc.initWithFrame [[x, y], [w, h]]
      image_view.layer.borderWidth = 1.5
      image_view.hidden = true
      x += image_view.width + padding
      contentView.addSubview image_view
      drivers_image_views.push image_view
    end
  end
end