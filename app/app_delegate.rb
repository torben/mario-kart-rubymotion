class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    set_defaults

    User.deserialize_from_file('users.dat')
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @window.rootViewController = initialRootViewController

    @window.makeKeyAndVisible

    if launchOptions
      remoteNotification = launchOptions[:UIApplicationLaunchOptionsRemoteNotificationKey]
      openWith(remoteNotification) if remoteNotification
    end

    loadNotificationConfig
    loadResources

    true
  end

  def set_defaults
    textTitleOptions = {UITextAttributeTextColor => '#1A91EE'.to_color, UITextAttributeFont => UIFont.fontWithName("Montserrat-Regular", size:17)}
    UINavigationBar.appearance.setTitleTextAttributes(textTitleOptions)
    UINavigationBar.appearance.setBackgroundImage(UIImage.new, forBarPosition:UIBarPositionAny, barMetrics:UIBarMetricsDefault)
    UINavigationBar.appearance.setBackgroundColor UIColor.whiteColor
    UINavigationBar.appearance.setShadowImage UIImage.new
  end

  def loadResources
    Vehicle.fetch(Vehicle.url) do
      Vehicle.serialize_to_file('vehicles.dat')
    end

    Character.fetch(Character.url) do
      Character.serialize_to_file('characters.dat')
    end
  end

  def initialRootViewController
    if User.current_user.present?
      MenuViewController.new
    else
      LoginViewController.new
    end
  end

  def applicationDidEnterBackground(application)
    User.serialize_to_file('users.dat')
  end

  private

    def loadNotificationConfig
      # deviceUDID = UIDevice.currentDevice.uniqueIdentifier
      # BW::HTTP.get("#{config[:host]}/devices/#{deviceUDID}.json") do |response|
      #   if response.ok?
      #     json = BW::JSON.parse(response.body)
      #     App::Persistence['notifications'] = json[:notifications]
      #     App::Persistence['notification_games']   = json[:notification_games]
      #     App::Persistence['notification_authors'] = json[:notification_authors]
      #   end
      # end
    end

    def openWith(remoteNotification)

    end
end
