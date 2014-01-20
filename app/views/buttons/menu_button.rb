class MenuButton < RPButton
  def initWithFrame(frame)
    if super
      setButton
    end

    self
  end

  def init
    if super
      setButton
    end

    self
  end

  def setButton
    self.setTitleColor(UIColor.whiteColor, forState:UIControlStateNormal)
    self.backgroundColor = UIColor.redColor
    self.layer.borderColor = UIColor.blackColor.CGColor
    self.layer.borderWidth = 0.5
    self.layer.cornerRadius = 10.0
  end
end