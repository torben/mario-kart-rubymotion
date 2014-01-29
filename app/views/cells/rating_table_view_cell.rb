class RatingTableViewCell < UITableViewCell
  attr_accessor :avatar_image_view, :text_label, :count_label

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super

    setup_view

    self
  end

  def setup_view
    @avatar_image_view = RPProfileImageView.alloc.initWithFrame [[3, 3], [38, 38]]
    @avatar_image_view.layer.borderWidth = 1.5
    @text_label = RPLabel.alloc.initWithFrame [[50, 3], [240, 38]]
    @count_label = RPLabel.alloc.initWithFrame [[290, 3], [30, 38]]

    addSubviews @avatar_image_view, @text_label, @count_label
  end
end