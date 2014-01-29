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
    self.layer.borderColor = '#D8D8D8'.to_color.CGColor
    self.layer.borderWidth = 3
    self.layer.cornerRadius = width / 2
    self.layer.masksToBounds = true
    self.textAlignment = UITextAlignmentCenter
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