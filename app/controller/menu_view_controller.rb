class MenuViewController < RPViewController
  attr_accessor :page_view_controller

  def viewDidLoad
    super

    SoundPlayer.instance.play_sound "mk64_multiplayerstart.wav"

    self.page_view_controller = UIPageViewController.alloc.initWithTransitionStyle(UIPageViewControllerTransitionStyleScroll, navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal, options:nil)
    page_view_controller.delegate = self

    collectionViewLayout = UICollectionViewFlowLayout.new

    left_vc = UINavigationController.alloc.initWithRootViewController RatingViewController.new
    middle_vc = UINavigationController.alloc.initWithRootViewController InviteCupViewController.alloc.initWithCollectionViewLayout(collectionViewLayout)
    right_vc = UINavigationController.alloc.initWithRootViewController FinishCupViewController.alloc.initWithStyle UITableViewStylePlain
    @viewControllers = [left_vc, middle_vc, right_vc]

    page_view_controller.setViewControllers([middle_vc], direction:UIPageViewControllerNavigationDirectionForward, animated:false, completion:nil)

    page_view_controller.dataSource = self
    page_view_controller.delegate = self
    page_view_controller.view.subviews.each do |v|
      v.delegate = self if v.respond_to?(:delegate=)
    end

    addChildViewController page_view_controller
    view.addSubview page_view_controller.view

    # Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    page_view_rect = view.bounds
    page_view_controller.view.frame = page_view_rect
    page_view_controller.didMoveToParentViewController self

    # Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    # view.gestureRecognizers = page_view_controller.gestureRecognizers

    EM.add_timer 1.0, Proc.new {
      UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
    }.weak!
  end

  def pageViewController(page_view_controller, viewControllerBeforeViewController:viewController)
    bounces(true)
    index = @viewControllers.index(viewController)
    if index.blank? || index == 0
      bounces(false)
      return
    end

    index -= 1

    @viewControllers[index]
  end

  def pageViewController(page_view_controller, viewControllerAfterViewController:viewController)
    bounces(true)
    index = @viewControllers.index(viewController)
    return if index.blank?

    index += 1

    if index >= @viewControllers.length
      bounces(false)
      return
    end

    @viewControllers[index]
  end

  def bounces(bounce)
    return # TODO this is not 100% working. Sometimes no scroll is possible on the center controller.
    page_view_controller.view.subviews.each do |v|
      v.bounces = bounce if v.respond_to?(:bounces)
    end
  end

  def goto_vc_at_position(position, direction = UIPageViewControllerNavigationDirectionForward, animated = true)
    page_view_controller.setViewControllers([@viewControllers[position]], direction:direction, animated:animated, completion:nil)
  end

  def vc_at_position(position)
    vc = @viewControllers[position]
    vc = vc.visibleViewController if vc.is_a?(UINavigationController)

    vc
  end
end