class InviteCollectionViewCell < UICollectionViewCell
  attr_accessor :image_view, :name_label, :points_label, :overlay_image_view

  def initWithFrame(frame)
    if super
      setup_view
    end

    self
  end

  def setup_view
    @border_width = 3
    padding = 10
    x, y = padding, padding
    self.image_view = RPImageView.alloc.initWithFrame [[x, y], [80, 80]]
    self.overlay_image_view = RPImageView.alloc.initWithFrame [[x, y], [80, 80]]
    x = 0
    y = y + image_view.height + (padding / 2)

    self.name_label = RPLabel.alloc.initWithFrame [[x, y], [100, 16]]
    y = y + name_label.height + (padding / 2)

    self.points_label = RPLabel.alloc.initWithFrame [[x, y], [100, 14]]

    image_view.layer.borderColor = '#D8D8D8'.to_color.CGColor
    image_view.layer.borderWidth = @border_width
    image_view.layer.cornerRadius = image_view.width / 2
    image_view.layer.masksToBounds = true

    overlay_image_view.image = UIImage.imageNamed "invite_checked"
    overlay_image_view.alpha = 0

    name_label.textAlignment = UITextAlignmentCenter
    name_label.set_font_size 13
    name_label.textColor = '#A1A1A1'.to_color
    points_label.textAlignment = UITextAlignmentCenter
    points_label.set_font_size 11
    points_label.textColor = '#CBCBCB'.to_color

    contentView.addSubviews image_view, overlay_image_view, name_label, points_label
  end

  def update_cell_selection
    if selected?
      image_view.layer.borderWidth = 0
      overlay_image_view.alpha = 1
    else
      image_view.layer.borderWidth = @border_width
      overlay_image_view.alpha = 0
    end
  end

  alias_method :selected?, :isSelected

  # def selected?
  #   @selected == true
  # end

  # def selected=(selected)
  #   @selected = selected
  # end
end