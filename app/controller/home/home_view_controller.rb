class HomeViewController < RPViewController
  def viewDidLoad
    super

    self.title = "Willkommen #{User.current_user.nickname}!"

    view.backgroundColor = UIColor.whiteColor

    @header_view = UIImageView.alloc.initWithImage UIImage.imageNamed("mario_kart.jpg")
    @start_button = MenuButton.buttonWithType(UIButtonTypeCustom)
    @start_button.setTitle("Starte ein Spiel", forState:UIControlStateNormal)
    @start_button.addTarget(self, action:"startCup", forControlEvents:UIControlEventTouchUpInside)

    @table_button = MenuButton.buttonWithType(UIButtonTypeCustom)
    @table_button.setTitle("Zeige die Tabelle", forState:UIControlStateNormal)
    @table_button.addTarget(self, action:"showRating", forControlEvents:UIControlEventTouchUpInside)

    @best_user_view = best_user_view

    view.addSubviews @header_view, @start_button, @table_button, @best_user_view
  end

  def viewDidLayoutSubviews
    padding = 10
    y = self.navigationController.navigationBar.height + UIApplication.sharedApplication.statusBarFrame.size.height
    w = view.width - (padding * 2)

    @header_view.frame = [[0, y], [view.width, 180]]
    y += @header_view.height + padding

    @start_button.frame = [[padding, y], [w, 40]]
    y += @start_button.height + padding

    @table_button.frame = [[padding, y], [w, 40]]
    y += @table_button.height + padding

    @best_user_view.frame = [[0, view.height - @best_user_view.height], [@best_user_view.width, @best_user_view.height]]
  end

  def best_user_view
    best_user_view = BestUserView.alloc.initWithFrame [[0,0], [view.width, 150]]
    User.fetch("#{User.url}/best_user") do |user|
      best_user_view.user = user
    end

    best_user_view
  end

  def startCup
    # Cup.fetch("#{Cup.url}/61") do |l_cap|
    #   cup = Cup.find(61)
    #   cup_view_controller = CupViewController.alloc.initWithStyle UITableViewStyleGrouped
    #   navigationController.pushViewController(cup_view_controller, animated: true)
    #   cup_view_controller.cup = cup
    # end

    # return
    navigationController.pushViewController(NewCupViewController.new, animated: true)
  end

  def showRating
    navigationController.pushViewController(RatingViewController.new, animated: true)
  end
end