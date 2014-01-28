class ModelSettingsTableViewCell < UITableViewCell
  attr_reader :image_view, :label_field

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super
      setup_view
    end

    self
  end

  def setup_view
    padding = 10
    x, y = padding, padding

    self.backgroundColor = '#F0F0F0'.to_color
    self.contentView.backgroundColor = '#F0F0F0'.to_color

    @image_view = RPProfileImageView.alloc.initWithFrame [[x, y], [80, 80]]
    @image_view.backgroundColor = UIColor.whiteColor
    @image_view.contentMode = UIViewContentModeScaleAspectFit
    x += image_view.width + padding

    @label_field = RPLabel.alloc.initWithFrame [[x, y], [200, 80]]
    label_field.setFontSize 17

    bottom_line = UIView.alloc.initWithFrame [[0, @image_view.height + (padding * 2)], [width, 1]]
    bottom_line.backgroundColor = '#D3D3D3'.to_color

    contentView.addSubviews image_view, label_field, bottom_line
  end
end