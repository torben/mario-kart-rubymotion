class BestUserView < UIView
  attr_reader :user

  def init
    super

    configure_view

    self
  end

  def initWithFrame(frame)
    super(frame)

    configure_view

    self
  end

  def configure_view
    @best_user_label = RPLabel.alloc.initWithFrame [[0,0], [width, 50]]
    @best_user_label.fontSize = 35
    @best_user_label.text = "Bester Fahrer:"

    @avatar_image_view = RPImageView.alloc.initWithFrame [[0, 50], [100, 100]]
    @user_nickname_label = RPLabel.alloc.initWithFrame [[100, 50], [width - 100, 30]]

    addSubviews @best_user_label, @avatar_image_view, @user_nickname_label
  end

  def updateView
    @avatar_image_view.load_async_image user.avatar_url
    @user_nickname_label.text = user.nickname
  end

  def user=(user)
    @user = user

    updateView
  end
end