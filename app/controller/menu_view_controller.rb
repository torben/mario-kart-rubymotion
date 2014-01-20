class MenuViewController < RPViewController
  attr_accessor :page_view_controller

  def viewDidLoad
    self.page_view_controller = UIPageViewController.alloc.initWithTransitionStyle(UIPageViewControllerTransitionStyleScroll, navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal, options:nil)
    page_view_controller.delegate = self

    homeViewController = UINavigationController.alloc.initWithRootViewController HomeViewController.new
    homeViewController2 = UINavigationController.alloc.initWithRootViewController InviteCupViewController.new
    homeViewController3 = UINavigationController.alloc.initWithRootViewController RatingViewController.new
    @viewControllers = [homeViewController, homeViewController2, homeViewController3]

    page_view_controller.setViewControllers([homeViewController2], direction:UIPageViewControllerNavigationDirectionForward, animated:false, completion:nil)

    page_view_controller.dataSource = self

    addChildViewController page_view_controller
    view.addSubview page_view_controller.view

    # Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    page_view_rect = view.bounds
    page_view_controller.view.frame = page_view_rect

    page_view_controller.didMoveToParentViewController self

    # Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    view.gestureRecognizers = self.page_view_controller.gestureRecognizers
  end

  def pageViewController(page_view_controller, viewControllerBeforeViewController:viewController)
    index = @viewControllers.index(viewController)
    return if index.blank? || index == 0

    index -= 1

    @viewControllers[index]
  end

  def pageViewController(page_view_controller, viewControllerAfterViewController:viewController)
    index = @viewControllers.index(viewController)
    return if index.blank?

    index += 1

    return if index >= @viewControllers.length

    @viewControllers[index]
  end
end