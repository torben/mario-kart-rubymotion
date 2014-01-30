class UserDetailView < UIView
  attr_accessor :user

  def initWithFrame(frame)
    super

    configure_view

    self
  end

  def configure_view
    padding = 10
    x = padding
    y = padding

    w = width
    @user_image_view = RPProfileImageView.alloc.initWithFrame [[x, y], [90, 90]]
    x += @user_image_view.width + padding
    w -= @user_image_view.width

    @user_name_label = RPLabel.alloc.initWithFrame [[x, y], [w, 90]]
    y += @user_image_view.height + padding

    addSubviews @user_image_view, @user_name_label
  end

  def user=(user)
    @user_image_view.load_async_image user.avatar_url
    @user_name_label.text = user.nickname
  end
end