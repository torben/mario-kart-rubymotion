class PlacementLabel < RPLabel
  def initWithFrame(frame)
    if super
      setup_view
    end

    self
  end

  def init
    if super
      setup_view
    end

    self
  end

  def setup_view
    layer.borderColor = '#D8D8D8'.to_color.CGColor
    layer.borderWidth = 3
    layer.cornerRadius = width / 2
    layer.masksToBounds = true

    self.textAlignment = UITextAlignmentCenter
    self.backgroundColor = '#ffffff'.to_color
  end

  def set_placement_border(placement)
    color = case placement
    when 1 then 'green'
    when 2 then '#ffe400'
    when 3 then '#ff9000'
    when 4 then 'red'
    end

    self.layer.borderColor = color.to_color.CGColor if color.present?
  end

  def text=(text)
    set_placement_border(text.to_i)

    super
  end
end