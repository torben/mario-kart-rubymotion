class NewCupViewController < RPViewController
  def viewDidLoad
    super

    self.view = UIScrollView.alloc.initWithFrame self.view.bounds

    self.title = "Neuen Cup anlegen"
    view.backgroundColor = UIColor.whiteColor

    @motor_class_label = RPLabel.new
    @motor_class_label.text = "Motorklasse"
    @motor_class_segment = RPSegmentedControl.alloc.initWithItems ["50 ccm", "100 ccm", "150 ccm"]
    @motor_class_segment.selectedSegmentIndex = 2

    @com_label = RPLabel.new
    @com_label.text = "COM"
    @com_segment = RPSegmentedControl.alloc.initWithItems ["Leicht", "Normal", "Schwer"]
    @com_segment.selectedSegmentIndex = 2

    @item_label = RPLabel.new
    @item_label.text = "Items"
    @item_segment = RPSegmentedControl.alloc.initWithItems ["Standard", "Furios", "Einfach", "Keine"]
    @item_segment.selectedSegmentIndex = 1

    @track_label = RPLabel.new
    @track_label.text = "Rennen"
    @track_segment = RPSegmentedControl.alloc.initWithItems %w(1 2 3 4 5 16 32)
    @track_segment.selectedSegmentIndex = 3

    @character_label = RPLabel.new
    @character_label.text = "Dein Fahrer"
    @character_text_field = RPLabel.new
    @character_text_field.text = last_character_text
    @character_text_field.userInteractionEnabled = true
    @character_text_field.addGestureRecognizer UITapGestureRecognizer.alloc.initWithTarget(self, action:"select_character")

    @vehicle_label = RPLabel.new
    @vehicle_label.text = "Dein Fahrzeug"
    @vehicle_text_field = RPLabel.new
    @vehicle_text_field.text = last_vehicle_text
    @vehicle_text_field.userInteractionEnabled = true
    @vehicle_text_field.addGestureRecognizer UITapGestureRecognizer.alloc.initWithTarget(self, action:"select_vehicle")

    @character_text_field

    @submit_button_view = MenuButton.buttonWithType(UIButtonTypeCustom)
    @submit_button_view.setTitle("Spieler einladen", forState:UIControlStateNormal)
    @submit_button_view.addTarget(self, action:"invite", forControlEvents:UIControlEventTouchUpInside)

    view.addSubviews @motor_class_label, @motor_class_segment, @com_label, @com_segment, @item_label, @item_segment
    view.addSubviews @track_label, @track_segment, @character_label, @character_text_field, @vehicle_label, @vehicle_text_field
    view.addSubviews @submit_button_view
  end

  def viewDidLayoutSubviews
    super

    padding = 5
    break_padding = 20
    y = padding #self.navigationController.navigationBar.height
    w = view.width - (padding * 2)

    [[@motor_class_label, @motor_class_segment], [@com_label, @com_segment], [@item_label, @item_segment], [@track_label, @track_segment], [@character_label, @character_text_field], [@vehicle_label, @vehicle_text_field]].each do |arr|
      label, input = arr

      label.frame = [[padding, y], [w, 20]]
      y += label.height + padding

      input.frame = [[padding, y], [w, 30]]
      y += input.height + break_padding
    end

    @submit_button_view.frame = [[padding, y], [w, 40]]
    y += @submit_button_view.height + padding

    view.contentSize = [view.width, y]
  end

  def automaticallyAdjustsScrollViewInsets
    true
  end

  def last_character_text
    name = ""
    if user.last_character_id.present?
      name = Character.find(user.last_character_id).try(:name)
    end

    if name == ""
      name = Character.first.try(:name)
    end

    name
  end

  def last_vehicle_text
    name = ""
    if user.last_vehicle_id.present?
      name = Vehicle.find(user.last_vehicle_id).try(:name)
    end

    if name == ""
      name = Vehicle.first.try(:name)
    end

    name
  end

  def user
    @user ||= User.current_user
  end

  def invite
    return if @inviting == true

    @inviting = true

    cup = Cup.new
    cup.host_user_id = user.id
    cup.motor_class = @motor_class_segment.titleForActiveSegment
    cup.com = @com_segment.titleForActiveSegment
    cup.items = @item_segment.titleForActiveSegment
    cup.num_tracks = @track_segment.titleForActiveSegment

    params = {
      params: {
        api_key: user.api_key
      }
    }

    cup.save_remote(params) do |new_cup|

      vehicle_id = selected_vehicle.try(:id)
      character_id = selected_character.try(:id)

      cup_member = CupMember.new({user_id: user.id, cup_id: new_cup.id, vehicle_id: vehicle_id, character_id: character_id, state: 'accepted'})
      cup_member.save_remote(params) do |new_cup_member|
        inviteVC = InviteCupViewController.new
        inviteVC.cup = Cup.find(new_cup.id)
        navigationController.pushViewController(inviteVC, animated: true)
        @inviting = false
      end
    end
  end

  def select_character
    select_model Character.order(:name).all
  end

  def select_vehicle
    select_model Vehicle.where(:size).eq(selected_character.size).order(:name).all
  end

  def select_model(models)
    model_select_view_controller = ModelSelectViewController.new
    nav_vc = UINavigationController.alloc.initWithRootViewController model_select_view_controller

    presentViewController nav_vc, animated: true, completion: nil
    model_select_view_controller.models = models
  end

  def model_selected(model)
    dismissViewControllerAnimated(true, completion:nil)
    return if model.blank?

    case model.class.name
    when "Vehicle"
      @vehicle_text_field.text = model.name
    when "Character"
      @character_text_field.text = model.name

      if selected_vehicle.size != model.size
        @vehicle_text_field.text = Vehicle.where(:size).eq(model.size).first.try(:name)
      end
    end
  end

  def selected_character
    Character.where(:name).eq(@character_text_field.text).first
  end

  def selected_vehicle
    Vehicle.where(:name).eq(@vehicle_text_field.text).first
  end
end
