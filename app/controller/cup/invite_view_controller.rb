class InviteViewController < RPViewController
  attr_accessor :cup, :cup_member_views

  def initWithCup(cup)
    if init
      self.cup = cup
    end

    self
  end

  def viewDidLoad
    super

    SoundPlayer.instance.play_sound "mk64_announcer06-jp.wav"

    @image_size = 90
    @member_size = 60
    @padding = 10
    @n_width = 100
    @n_height = 16
    self.cup_member_views = {}

    self.title = "We Need You!"
    view.backgroundColor = '#F0F0F0'.to_color

    @host_image_view = RPProfileImageView.alloc.initWithFrame [[0, 0], [@image_size, @image_size]]
    @host_image_view.hidden = true

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
      will_join(false) do
        close_invite
      end
    }.weak!)

    close_button = UIBarButtonItem.alloc.initWithTitle("Close", style: UIBarButtonItemStylePlain, target:self, action:"no_invite")
    navigationItem.rightBarButtonItem = close_button

    set_user_text

    EM.add_timer 1 do
      animate_host_to_the_top
    end

    view.addSubviews @host_image_view, @nickname_label, @start_button, @cancel_button

    cup_members = CupMember.where(:cup_id).eq(cup.id).and(:user_id).ne(cup.host_user_id).and(:state).in(['invited', 'accepted'])

    cup_members.each do |cup_member|
      cup_member_view = RPProfileImageView.alloc.initWithFrame [[0, 0], [@member_size, @member_size]]
      cup_member_view.alpha = 0
      cup_member_views[cup_member.id] = cup_member_view

      view.addSubview cup_member_view
    end
  end

  def viewWillAppear(animated)
    super

    @start_button.alpha = 1
    @cancel_button.alpha = 1
    @host_image_view.hidden = false

    b_height = 60
    b_width = view.width - (@padding * 2)
    h = (@n_height + @host_image_view.height) - (@padding / 2)

    x = @padding
    y = view.height - (b_height + @padding)
    @cancel_button.frame = [[x, y], [b_width, b_height]]
    y -= @cancel_button.height + @padding

    @start_button.frame = [[x, y], [b_width, b_height]]
    y -= @start_button.height

    x = (view.width / 2) - (@host_image_view.width / 2)
    y = (y - (@host_image_view.height / 2)) / 2

    @host_image_view.frame = [[x, y], [@image_size, @image_size]]
    @host_image_view.transform = CGAffineTransformMakeScale(2.0, 2.0)

    x -= (@n_width - @image_size) / 2
    y += @host_image_view.height + (@padding / 2)

    @nickname_label.frame = [[x, y], [@n_width, @n_height]]
    @nickname_label.transform = CGAffineTransformMakeScale(2.0, 2.0)
  end

  def animate_host_to_the_top
    x = (view.width / 2) - (@image_size / 2)
    y = @padding

    UIView.animateWithDuration(0.6, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      @host_image_view.transform = CGAffineTransformIdentity
      @host_image_view.frame = [[x, y], [@image_size, @image_size]]

      x -= (100 - @image_size) / 2
      y += @image_size + (@padding / 2)

      @nickname_label.transform = CGAffineTransformIdentity
      @nickname_label.frame = [[x, y], @nickname_label.frame.size]
    }.weak!, completion: Proc.new { |completed|
      show_cup_members
    }.weak!)

    NSNotificationCenter.defaultCenter.addObserver(self, selector:'data_did_change:', name:'MotionModelDataDidChangeNotification', object:nil)
  end

  def viewWillDisappear(animated)
    super

    NSNotificationCenter.defaultCenter.removeObserver self
  end

  def data_did_change(notification)
    model = notification.object
    return unless model.is_a?(CupMember)
    return unless cup_member_views.has_key?(model.id)

    if model.state == 'accepted'
      UIView.animateWithDuration(0.3, delay:0.0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        cup_member_views[model.id].alpha = 1.0
        wubbel(cup_member_views[model.id])
      }, completion:nil)
    elsif model.state == 'rejected'
      UIView.animateWithDuration(0.5, delay:0.0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        cup_member_views[model.id].alpha = 0.0
      }, completion: Proc.new { |completed|
        cup_member_views[model.id].removeFromSuperview
        cup_member_views.delete model.id
        show_cup_members(false)
      })
    end
  end

  def show_cup_members(with_delay = true)
    canvas_width = view.width - (@padding * 2)
    count = (canvas_width / (@member_size + @padding)).floor
    if count > cup_member_views.length
      count = cup_member_views.length
    end
    all_count = count + 2

    b_padding = (view.width - (@member_size * count)) / (all_count - 1)
    delay = 0
    delay_step = 0.15

    start_x = view.center.x
    start_y = 500

    x = b_padding
    y = @nickname_label.y + @nickname_label.height + (@padding * 2)

    cup_member_views.each_with_index do |obj, i|
      cup_member_id = obj[0]
      cup_member = CupMember.find(cup_member_id)
      view = obj[1]
      user = CupMember.find(cup_member_id.to_i).user
      next if user.blank?

      view.load_async_image user.avatar_url
      if view.x == 0
        origin = [start_x, start_y]
        size = [@image_size, @image_size]
      else
        origin = [view.x, view.y]
        size = [@member_size, @member_size]
      end
      view.frame = [origin, size]

      alpha = cup_member.state == "accepted" ? 1.0 : 0.5

      UIView.animateWithDuration(0.2, delay:delay, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        view.alpha = alpha
        view.frame = [[x, y], [@member_size, @member_size]]
      }.weak!, completion:nil)

      x += b_padding + @member_size

      if i + 1 == count
        x = b_padding
        y += @padding + @member_size
      end

      delay += delay_step if with_delay
    end
  end

  def host_user
    @host_user || User.find(cup.host_user_id)
  end

  def set_user_text
    if host_user.blank?
      User.fetch("#{User.url}/#{host_user.id}") do |user|
        @nickname_label.text = user.nickname
        @host_image_view.load_async_image user.avatar_url
      end
    else
      @nickname_label.text = host_user.nickname
      @host_image_view.load_async_image host_user.avatar_url
    end
  end

  def will_join(answer, &block)
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
      block.call if block.present? && block.respond_to?(:call)
    end
  end

  def no_invite
    close_invite
  end

  def close_invite
    dismissModalViewControllerAnimated(true)
  end
end