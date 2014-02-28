class UserCupDetailTableViewCell < UITableViewCell
  attr_accessor :placement_label, :points_label, :drivers_image_views

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      setup_view
    end

    self
  end

  def setup_view
    self.drivers_image_views = []
    self.backgroundColor = '#F0F0F0'.to_color
    number_of_playaz = 4

    x = 10
    y = 5
    w = 40
    h = 40

    padding = ((width - (x * 2)) - (w * (number_of_playaz + 2))) / (number_of_playaz + 1)

    @placement_label = PlacementLabel.alloc.initWithFrame [[x, y], [w, h]]
    x += w + padding

    #@character_image_view = RPImageView.alloc.initWithFrame [[x, y], [w, h]]
    #x += w + padding

    #@vehicle_image_view = RPImageView.alloc.initWithFrame [[x, y], [58, h]]
    #x += @vehicle_image_view.width + padding

    @points_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]
    @points_label.textAlignment = UITextAlignmentCenter
    x += @points_label.width + padding

    contentView.addSubviews @placement_label, @points_label

    for i in -1..number_of_playaz
      image_view = RPProfileImageView.alloc.initWithFrame [[x, y], [w, h]]
      image_view.layer.borderWidth = 1.5
      image_view.hidden = true
      x += image_view.width + padding
      contentView.addSubview image_view
      drivers_image_views.push image_view
    end
  end
end