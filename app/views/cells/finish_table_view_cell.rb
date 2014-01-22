class FinishTableViewCell < UITableViewCell
  attr_reader :image_view, :nickname_label, :input_field, :points_label

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

    @nickname_label = RPLabel.alloc.initWithFrame [[x, y], [100, image_view.height]]
    nickname_label.setFontSize 17
    x += nickname_label.width + padding

    @input_field = FinishTextField.alloc.initWithFrame [[x, y], [100, 58]]
    input_field.setFontSize 48
    input_field.textAlignment = UITextAlignmentCenter
    input_field.clearsOnBeginEditing = true
    input_field.keyboardType = UIKeyboardTypeNumbersAndPunctuation

    y += input_field.height - 10
    @points_label = RPLabel.alloc.initWithFrame [[x, y], [100, 16]]
    points_label.setFontSize 13
    points_label.textAlignment = UITextAlignmentCenter

    bottom_line = UIView.alloc.initWithFrame [[0, @image_view.height + (padding * 2)], [width, 1]]
    bottom_line.backgroundColor = '#D3D3D3'.to_color

    contentView.addSubviews input_field, nickname_label, image_view, points_label, bottom_line
  end
end