class InviteViewController < RPViewController
  attr_accessor :cup

  def initWithCup(cup)
    if init
      self.cup = cup
    end

    self
  end

  def viewDidLoad
    super

    SoundPlayer.instance.play_sound "mk64_announcer06-jp.wav"

    self.title = "We Need You!"
    view.backgroundColor = '#F0F0F0'.to_color

    @image_view = RPProfileImageView.alloc.initWithFrame [[0, 0], [80, 80]]
    @image_view.hidden = true

    @nickname_label = RPLabel.new
    @nickname_label.textAlignment = UITextAlignmentCenter
    @nickname_label.set_font_size 13
    @nickname_label.textColor = '#A1A1A1'.to_color

    @start_button = RPButton.blue_button
    @start_button.setTitle('Annehmen', forState:UIControlStateNormal)
    @start_button.when(UIControlEventTouchUpInside, &Proc.new {
      will_join(true)
    }.weak!)

    @cancel_button = RPButton.white_button
    @cancel_button.setTitle('Ablehnen', forState:UIControlStateNormal)
    @cancel_button.when(UIControlEventTouchUpInside, &Proc.new {
      will_join(false)
    }.weak!)

    close_button = UIBarButtonItem.alloc.initWithTitle("Cancel", style: UIBarButtonItemStylePlain, target:self, action:"no_invite")
    navigationItem.rightBarButtonItem = close_button

    set_user_text

    view.addSubviews @image_view, @nickname_label, @start_button, @cancel_button
  end

  def viewDidLayoutSubviews
    @start_button.alpha = 1
    @cancel_button.alpha = 1
    @image_view.hidden = false

    padding = 10
    b_height = 60
    b_width = view.width - (padding * 2)
    n_width = 100
    n_height = 16
    h = (n_height + @image_view.height) - (padding / 2)

    x = padding
    y = view.height - (b_height + padding)
    @cancel_button.frame = [[x, y], [b_width, b_height]]
    y -= @cancel_button.height + padding

    @start_button.frame = [[x, y], [b_width, b_height]]
    y -= @start_button.height

    x = (view.width / 2) - 40
    y = (y - h) / 2

    @image_view.frame = [[x, y], [80, 80]]
    x = (view.width / 2) - (n_width / 2)
    y += @image_view.height + (padding / 2)

    @nickname_label.frame = [[x, y], [n_width, n_height]]
  end

  def host_user
    @host_user || User.find(cup.host_user_id)
  end

  def set_user_text
    if host_user.blank?
      User.fetch("#{User.url}/#{host_user.id}") do |user|
        @nickname_label.text = user.nickname
        @image_view.load_async_image user.avatar_url
      end
    else
      @nickname_label.text = host_user.nickname
      @image_view.load_async_image host_user.avatar_url
    end
  end

  def will_join(answer)
    UIView.animateWithDuration(0.6, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      @start_button.alpha = 0
      @cancel_button.alpha = 0
    }, completion: nil)

    cup_member = CupMember.where(:cup_id).eq(cup.id).and(:user_id).eq(current_user.id).first

    cup_member.state = "rejected"
    if answer == true
      SoundPlayer.instance.play_sound "mk64_announcer11-jp.wav"
      cup_member.state = "accepted"
    end

    cup_member.save_remote(params) do |model|
      alert = App.alert(answer == true ? "OK, let's roll baby..." : "Maybe next time")
      alert.delegate = self
    end
  end

  def no_invite
    will_join(false)
  end

  def alertView(alertView, clickedButtonAtIndex:index)
    close_invite
  end

  def close_invite
    dismissModalViewControllerAnimated(true)
  end
end