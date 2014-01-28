class UserSettingsTableViewCell < UITableViewCell
  attr_reader :image_view, :input_field

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
    x += image_view.width + padding

    @input_field = RPTextField.alloc.initWithFrame [[x, y], [200, 80]]
    input_field.setFontSize 17

    bottom_line = UIView.alloc.initWithFrame [[0, @image_view.height + (padding * 2)], [width, 1]]
    bottom_line.backgroundColor = '#D3D3D3'.to_color

    contentView.addSubviews input_field, image_view, bottom_line
  end
end