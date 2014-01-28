class RPProfileImageView < RPImageView
  def initWithFrame(frame)
    if super
      setup_view
    end

    self
  end

  def initWithImage(image)
    if super
      setup_view
    end
  end

  def init
    if super
      setup_view
    end
  end

  def setup_view
    layer.borderColor = '#D8D8D8'.to_color.CGColor
    layer.borderWidth = 3
    layer.cornerRadius = width / 2 if width.present?
    layer.masksToBounds = true
    self.contentMode = UIViewContentModeScaleAspectFill
  end
end