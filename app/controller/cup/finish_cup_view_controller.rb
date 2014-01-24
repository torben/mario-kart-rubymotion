class FinishCupViewController < RPTableViewController
  include FinishCup::TableViewDatasource
  include FinishCup::TableViewDelegate
  include FinishCup::DeleteHandler
  include FinishCup::TextField

  attr_reader :cup
  attr_accessor :saved_item_count, :timer

  def viewDidLoad
    @cached_images = {}
    self.title = "Fill in the results"

    tableView.registerClass(FinishTableViewCell, forCellReuseIdentifier:"Cell")
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    tableView.separatorColor = UIColor.clearColor
    tableView.backgroundColor = '#F0F0F0'.to_color

    gesture = UILongPressGestureRecognizer.alloc.initWithTarget(self, action:"start_deleting:")
    tableView.addGestureRecognizer(gesture)

    close_button = UIBarButtonItem.alloc.initWithTitle("Done", style: UIBarButtonItemStylePlain, target:self, action:"close_cup")
    navigationItem.rightBarButtonItem = close_button
  end

  def viewWillAppear(animated)
    super(animated)

    reload_cup
  end

  def viewWillDisappear(animated)
    super

    cancel_timer
  end

  def cup=(cup)
    @cup = cup

    reload
  end

  def reload
    tableView.reloadData
    # update_start_button

    reload_cup
  end

  def reload_cup
    return if cup.blank?
    cancel_timer

    self.timer = EM.add_timer 10.0 do
      LoadingView.show("Reloading")
      Cup.fetch("#{Cup.url}/#{cup.id}") do |l_cap|
        self.cup = Cup.find(l_cap.id)
        LoadingView.hide
      end
    end
  end

  def cancel_timer
    EM.cancel_timer(timer) if timer.present?
  end

  def cup_members
    cup_members = active_cup_members
    cup_members << cup.invited_members
    cup_members.flatten
  end

  def active_cup_members
    active_cup_members = [cup.hosting_member]
    active_cup_members << cup.accepted_members
    active_cup_members.flatten
  end

  def close_cup
    placements = []
    for cup_member in active_cup_members
      if cup_member.points.blank?# || cup_member.placement.blank?
        App.alert "Please fill in the fields!"
        return
      end
    end

    LoadingView.show

    self.saved_item_count = 0
    cup_members.each do |cup_member|
      cup_member.save_remote(params) do
        self.saved_item_count += 1

        if saved_item_count == cup_members.length
          update_cup_and_redirect
        end
      end
    end
  end

  def update_cup_and_redirect
    winner = CupMember.where(:cup_id).eq(cup.id).and(:points).ne(nil).order{|one, two| two.points <=> one.points}.first
    cup.winning_user_id = winner.user.id

    cup.save_remote(params) do
      LoadingView.hide

      alert = App.alert("Thank You!")
      alert.delegate = self
    end
  end

  def alertView(alertView, clickedButtonAtIndex:index)
    menu_view_controller = App.window.rootViewController
    raise "Da ist was schief!" unless menu_view_controller.is_a?(MenuViewController)

    menu_view_controller.goto_vc_at_position(1, UIPageViewControllerNavigationDirectionReverse, true)
    self.cup = nil
  end
end