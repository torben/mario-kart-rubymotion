class RatingTableViewCell < UITableViewCell
  attr_accessor :avatar_image_view, :text_label, :count_label

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

    @avatar_image_view = RPProfileImageView.alloc.initWithFrame [[x, y], [w, h]]
    @avatar_image_view.layer.borderWidth = 1.5
    x += @avatar_image_view.width + padding

    text_width = width - (x + padding + w)
    @text_label = RPLabel.alloc.initWithFrame [[x, y], [text_width, h]]
    x += @text_label.width + padding

    @count_label = RPLabel.alloc.initWithFrame [[x, y], [w, h]]

    contentView.backgroundColor = '#F0F0F0'.to_color
    contentView.addSubviews @avatar_image_view, @text_label, @count_label
  end
end