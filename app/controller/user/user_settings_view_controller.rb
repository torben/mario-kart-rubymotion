class UserSettingsViewController < RPTableViewController
  include UserSettings::TableViewDatasource
  include UserSettings::TableViewDelegate
  include UserSettings::TextField

  attr_reader :cup
  attr_accessor :saved_item_count, :timer

  def viewDidLoad
    @cached_images = {}
    self.title = "User Settings"

    tableView.registerClass(UserSettingsTableViewCell, forCellReuseIdentifier:"UserCell")
    tableView.registerClass(ModelSettingsTableViewCell, forCellReuseIdentifier:"ModelCell")
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    tableView.separatorColor = UIColor.clearColor
    tableView.backgroundColor = '#F0F0F0'.to_color

    save_button = UIBarButtonItem.alloc.initWithTitle("Save", style: UIBarButtonItemStylePlain, target:self, action:"save_me")
    navigationItem.rightBarButtonItem = save_button

    # need to store attributes, because of special behaviour in motion model
    @last_vehicle_id = current_user.last_vehicle_id
    @last_character_id = current_user.last_character_id
    @nickname = current_user.nickname
    @avatar = nil
    @no_update = false
  end

  def viewWillAppear(animated)
    super
    tableView.reloadData
  end

  def viewDidDisappear(animated)
    super

    if navigationController.viewControllers.length == 1 && @no_update == false
      current_user.nickname = @nickname
      current_user.last_vehicle_id = @last_vehicle_id
      current_user.last_character_id = @last_character_id
      current_user.attributes.delete(:avatar_data)
      @avatar = nil
    end
  end

  def open_action_sheet
    sheet = UIActionSheet.alloc.initWithTitle("Choose Profile Picture Source", delegate:self, cancelButtonTitle:nil, destructiveButtonTitle:nil, otherButtonTitles:nil)
    sheet.addButtonWithTitle("Choose Photo")
    sheet.addButtonWithTitle("Take Photo")
    sheet.cancelButtonIndex = (sheet.addButtonWithTitle("Cancel"))
    sheet.showInView(App.window)
  end

  def actionSheet(actionSheet, clickedButtonAtIndex:buttonIndex)
    case buttonIndex
    when 0
      @no_update = true
      BW::Device.camera.any.picture(media_types: [:movie, :image]) do |result|
        update_image result[:original_image]
      end
    when 1
      unless Device.camera.front?
        return App.alert "There is no camera!"
      end
      @no_update = true
      BW::Device.camera.front.picture(media_types: [:image]) do |result|
        update_image result[:original_image]
      end
    end
  end

  def update_image(image)
    return if image.blank?

    current_user.attributes[:avatar_data] = image
    @avatar = image
    @no_update = false
  end

  def model_selected(model = nil)
    return if model.blank?

    case model.class.name
    when "Vehicle"   then current_user.last_vehicle_id = model.id
    when "Character" then current_user.last_character_id = model.id
    end

    tableView.reloadData
  end

  def save_me
    @last_vehicle_id = current_user.last_vehicle_id
    @last_character_id = current_user.last_character_id
    @nickname = current_user.nickname

    menu_view_controller = App.window.rootViewController
    raise "Da ist was schief!" unless menu_view_controller.is_a?(MenuViewController)

    LoadingView.show("Saving...")
    current_user.save_remote(params) do
      LoadingView.hide
      menu_view_controller.goto_vc_at_position(1, UIPageViewControllerNavigationDirectionReverse, true)
    end
  end
end