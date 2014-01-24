class InvitedView < UIView
  attr_accessor :results_button, :invited_image_view, :center_view, :close_button

  def initWithFrame(frame)
    if super
      setup_view
    end

    self
  end

  def setup_view
    self.backgroundColor = UIColor.colorWithRed(38.0/255.0, green:165.0/255.0, blue:239.0/255.0, alpha:0.9)
    w = 210
    h = 124

    self.center_view = UIView.alloc.initWithFrame [[(width / 2) - (w / 2), (height / 2) - (h / 2)], [w, h]]

    self.invited_image_view = UIImageView.alloc.initWithImage UIImage.imageNamed "invite-success"
    invited_image_view.frame = [[(center_view.width / 2) - 45, 0], [90, 90]]

    status_text_label = RPLabel.alloc.initWithFrame [[0, 103], [w, 21]]
    status_text_label.text = "Players are invited!"
    status_text_label.setFontSize 17
    status_text_label.textColor = UIColor.whiteColor
    status_text_label.textAlignment = UITextAlignmentCenter

    self.results_button = RPButton.white_button
    results_button.setTitle('Fill in the results', forState:UIControlStateNormal)
    results_button.layer.cornerRadius = 5
    results_button.frame = [[10, height - 70], [300, 60]]

    self.close_button = RPButton.custom
    close_button.setTitle('Close', forState:UIControlStateNormal)
    close_button.setTitleColor(UIColor.whiteColor, forState:UIControlStateNormal)
    close_button.frame = [[10, 10], [300, 21]]
    close_button.contentHorizontalAlignment = UITextAlignmentRight

    center_view.addSubviews invited_image_view, status_text_label
    addSubviews center_view, results_button, close_button
  end
end