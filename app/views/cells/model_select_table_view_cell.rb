class ModelSelectTableViewCell < UITableViewCell
  attr_accessor :image_view, :text_label

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super

    setup_view

    self
  end

  def setup_view
    @image_view = RPImageView.alloc.initWithFrame [[16, 3], [38, 38]]
    @text_label = RPLabel.alloc.initWithFrame [[70, 3], [240, 38]]

    addSubviews @image_view, @text_label
  end
end