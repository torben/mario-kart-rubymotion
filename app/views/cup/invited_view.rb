class InvitedView < UIView
  attr_accessor :results_button, :invited_image_view

  def initWithFrame(frame)
    if super
      setup_view
    end

    self
  end

  def setup_view
    self.backgroundColor = UIColor.colorWithRed(38.0/255.0, green:165.0/255.0, blue:239.0/255.0, alpha:0.9)

    self.invited_image_view = UIImageView.alloc.initWithImage UIImage.imageNamed "invite-success"
    invited_image_view.frame = [[50, 50], [90, 90]]

    self.results_button = RPButton.custom
    results_button.setTitle('Fill in the results', forState:UIControlStateNormal)
    results_button.setBackgroundColor '#fff'.to_color
    results_button.setTitleColor('#26A5EF'.to_color, forState:UIControlStateNormal)
    results_button.layer.cornerRadius = 5
    results_button.frame = [[10, height - 70], [300, 60]]

    addSubviews results_button, invited_image_view
  end
end