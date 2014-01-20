class RPButton < UIButton
  class << self
    def custom
      button = buttonWithType UIButtonTypeCustom
      button.configure_view
      button
    end
  end

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
    self.font = UIFont.fontWithName("Montserrat-Regular", size:17)
    self.backgroundColor = UIColor.clearColor
    self.setTitleColor(UIColor.blackColor, forState:UIControlStateNormal)
  end

  def setFontSize(fontSize)
    self.font = self.font.fontWithSize(fontSize)
    self.setMinimumFontSize(fontSize - 10.0)
  end
  alias_method :set_font_size, :setFontSize

  def fontSize
    font.pointSize
  end
end