class InviteCupViewController < RPCollectionViewController
  include Invite::CollectionViewDatasource
  include Invite::CollectionViewDelegate

  attr_accessor :cup, :users, :saved_item_count

  def viewDidLoad
    super

    @users = []
    @selected_driver = []
    @selected_rows = []

    self.title = "Select Players"
    collectionView.backgroundColor = '#F0F0F0'.to_color
    collectionView.registerClass(InviteCollectionViewCell, forCellWithReuseIdentifier:"Cell")
    collectionView.alwaysBounceVertical = true

    load_user

    @start_button = RPButton.blue_button
    @start_button.setTitle('Invite Lümmels', forState:UIControlStateNormal)
    @start_button.frame = [[10, view.height + 70], [300, 60]]
    @start_button.alpha = 0

    @invited_view = InvitedView.alloc.initWithFrame [[0,0], [Device.screen.width, Device.screen.height]]
    @invited_view.hidden = true
    @invited_view.close_button.addTarget(self, action:"close_invited_view", forControlEvents:UIControlEventTouchUpInside)
    @invited_view.close_button.hidden = true
    @invited_view.results_button.hidden = true

    @start_button.when(UIControlEventTouchUpInside, &Proc.new {
      @invited_view.center_view.alpha = 0
      @invited_view.hidden = false
      LoadingView.show

      cup = Cup.new
      cup.host_user_id = current_user.id

      cup.save_remote(params) do |new_cup|
        self.cup = Cup.find(new_cup.id)
        do_invite do
          LoadingView.hide
          show_invite_animation
        end
      end
    }.weak!)

    @invited_view.results_button.addTarget(self, action:"do_stats", forControlEvents:UIControlEventTouchUpInside)

    view.addSubview @start_button

    App.window.addSubview @invited_view
  end

  def viewWillAppear(animated)
    super

    @start_button.alpha = 0 if @selected_driver.length == 0
  end

  def load_user
    User.fetch(User.url) do |models|
      self.users = User.where(:id).ne(current_user.id).order(:nickname).all
      self.collectionView.reloadData
    end
  end

  def show_invite_animation
    @invited_view.center_view.alpha = 0
    EM.add_timer 0.4 do
      @invited_view.center_view.alpha = 1
      wubbel(@invited_view.center_view) do
        UIView.animateWithDuration(0.4, delay:1, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
          @invited_view.alpha = 0
        }, completion: lambda { |completed|
          @invited_view.alpha = 1
          do_stats
        })
      end
    end
  end

  def cup=(cup)
    @cup = cup
  end

  def wubbel(view, &block)
    animate_duration = 0.08

    UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      view.transform = CGAffineTransformMakeScale(0.9, 0.9)
    }, completion: lambda { |completed|
      UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        view.transform = CGAffineTransformMakeScale(1.08, 1.08)
      }, completion: lambda { |completed|
        UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
          view.transform = CGAffineTransformMakeScale(0.95, 0.95)
        }, completion: lambda { |completed|
          UIView.animateWithDuration(0.11, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
            view.transform = CGAffineTransformMakeScale(1.03, 1.03)
          }, completion: lambda { |completed|
            UIView.animateWithDuration(0.11, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
              view.transform = CGAffineTransformIdentity
            }, completion: lambda { |completed|
              block.call if block.present? && block.respond_to?(:call)
            })
          })
        })
      })
    })
  end

  def update_invite_button
    if @selected_driver.length <= 1
      @start_button.alpha = 1
      y = if @selected_driver.length == 0
        view.height + 200
      else
        view.height - @start_button.height - 10
      end

      UIView.animateWithDuration(0.4, delay:0.3, usingSpringWithDamping:0.75, initialSpringVelocity:20, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        @start_button.y = y
      }, completion: nil)
    end
  end

  def do_invite(&block)
    return if @selected_driver.length == 0

    @selected_driver.unshift current_user

    self.saved_item_count = 0
    @selected_driver.each do |user|
      cup_member = CupMember.new({ cup_id: cup.id, user_id: user.id, state: 'invited'})
      cup_member.save_remote(params) do
        self.saved_item_count += 1

        if saved_item_count == @selected_driver.length
          block.call if block.present? && block.respond_to?(:call)
        end
      end
    end
  end

  def close_invited_view
    deselect_all_items
    @invited_view.hidden = true
    @start_button.alpha = 0 if @selected_driver.length == 0
  end

  def do_stats
    close_invited_view

    menu_view_controller = App.window.rootViewController
    raise "Da ist was schief!" unless menu_view_controller.is_a?(MenuViewController)

    stats_controller = menu_view_controller.vc_at_position 2
    stats_controller.cup = cup

    EM.add_timer 0.2 do
      menu_view_controller.goto_vc_at_position(2, UIPageViewControllerNavigationDirectionForward, true)
    end
  end

  def show_invite(cup)
    vc = UINavigationController.alloc.initWithRootViewController InviteViewController.alloc.initWithCup(cup)
    presentViewController(vc, animated:true, completion:nil)
  end
end