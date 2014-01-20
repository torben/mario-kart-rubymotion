class RatingTableViewCell < UITableViewCell
  attr_accessor :user

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super

    setup_view

    self
  end

  def setup_view
    @avatar_image_view = RPImageView.alloc.initWithFrame [[3, 3], [38, 38]]
    @text_label = RPLabel.alloc.initWithFrame [[50, 3], [240, 38]]
    @count_label = RPLabel.alloc.initWithFrame [[290, 3], [30, 38]]

    addSubviews @avatar_image_view, @text_label, @count_label
  end

  def configure_view
    @avatar_image_view.load_async_image user.avatar_url
    @text_label.text = user.nickname
    @count_label.text = user.points_per_race.to_s
  end

  def user=(user)
    @user = user
    configure_view
  end
end