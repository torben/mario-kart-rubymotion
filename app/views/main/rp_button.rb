class RPButton < UIButton
  class << self
    def custom
      button = buttonWithType UIButtonTypeCustom
      button.configure_view
      button
    end

    def blue_button
      colored_button('#fff'.to_color, '#26A5EF'.to_color)
    end

    def white_button
      colored_button('#26A5EF'.to_color, '#fff'.to_color)
    end

    def colored_button(text_color, background_color)
      button = custom
      button.setTitleColor(text_color, forState:UIControlStateNormal)
      button.setBackgroundColor background_color
      button.layer.cornerRadius = 5
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