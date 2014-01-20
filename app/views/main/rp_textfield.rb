class RPTextField < UITextField
  def initWithFrame(frame)
    if super
      configure_view
    end

    self
  end

  def init
    if super
      configure_view
    end

    self
  end

  def configure_view
    self.font = UIFont.fontWithName("Avenir Next", size:17)
    self.backgroundColor = UIColor.clearColor
  end

  def setFontSize(fontSize)
    self.font = self.font.fontWithSize(fontSize)
    self.setMinimumFontSize(fontSize - 10.0)
  end

  def fontSize
    font.pointSize
  end
end