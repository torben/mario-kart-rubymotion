class InviteCupViewController < RPCollectionViewController
  attr_accessor :cup, :users, :saved_item_count

  def viewDidLoad
    super

    @users = []
    @selected_driver = []
    @active_button_color = '#26A5EF'.to_color
    @inactive_button_color = '#ACE0FE'.to_color

    self.title = "Kollege Invite"
    # self.tableView.registerClass(InviteTableViewCell, forCellReuseIdentifier:"Cell")
    collectionView.backgroundColor = '#F0F0F0'.to_color
    collectionView.registerClass(InviteCollectionViewCell, forCellWithReuseIdentifier:"Cell")
    collectionView.alwaysBounceVertical = true

    User.fetch(User.url) do |models|
      self.users = User.where(:id).ne(current_user.id).order(:nickname).all
      self.collectionView.reloadData
    end

    @start_button = RPButton.custom
    @start_button.setTitle('Start Game', forState:UIControlStateNormal)
    @start_button.setTitle('Zu viele Spieler!', forState:UIControlStateDisabled)
    @start_button.setTitleColor('#fff'.to_color, forState:UIControlStateNormal)
    @start_button.setBackgroundColor @active_button_color
    @start_button.layer.cornerRadius = 5
    @start_button.frame = [[10, view.height + 70], [300, 60]]
    @start_button.alpha = 0

    @start_button.addTarget(self, action:"do_invite", forControlEvents:UIControlEventTouchUpInside)

    view.addSubview @start_button
  end

  def cup=(cup)
    @cup = cup
  end

  def numberOfSectionsInCollectionView(collectionView)
    1
  end

  def collectionView(collectionView, numberOfItemsInSection:section)
    @users.length
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    user = users[indexPath.row]

    cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath:indexPath)

    cell.image_view.load_async_image user.avatar_url
    cell.name_label.text = user.nickname
    cell.points_label.text = "#{user.total_points} Punkte"

    #cell.cellSelection = UIColor.greenColor

    if @selected_driver.include?(user)
      # cell.accessoryType = UITableViewCellAccessoryCheckmark
    end

    cell
  end

  def collectionView(collectionView, didSelectItemAtIndexPath:indexPath)
    cell = collectionView.cellForItemAtIndexPath indexPath
    user = users[indexPath.row]

    if @selected_driver.include?(user)
      # cell.accessoryType = UITableViewCellAccessoryNone
      cell.selected = false
      @selected_driver.delete user
    else
      # return if @selected_driver.length >= 3
      cell.selected = true
      # cell.accessoryType = UITableViewCellAccessoryCheckmark
      @selected_driver.push user
    end

    wubbel(cell)
    update_invite_button

    # collectionView.deselectRowAtIndexPath(indexPath, animated:false)
  end

  def collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath:indexPath)
    CGSizeMake(100, 145)
  end

  def collectionView(collectionView, layout:collectionViewLayout, insetForSectionAtIndex:section)
    [15,10,15,10]
  end

  def collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: section)
    0
  end

  def collectionView(collectionView, layout:collectionViewLayout, minimumLineSpacingForSectionAtIndex: section)
    0
  end

  def wubbel(cell)
    end_frame = cell.contentView.frame
    small_frame = CGRectMake(end_frame.origin.x, end_frame.origin.y, cell.contentView.width * 1.3, cell.contentView.height * 1.3)

    animate_duration = 0.08

    UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      cell.update_cell_selection
      cell.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)

      # UIView.animateWithDuration(0.6, delay:0.0, usingSpringWithDamping:0.75, initialSpringVelocity:40, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      #   cell.contentView.transform = CGAffineTransformIdentity
      # }, completion: nil)
    }, completion: lambda { |completed|
      UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        cell.contentView.transform = CGAffineTransformMakeScale(1.08, 1.08)
      }, completion: lambda { |completed|
        UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
          cell.contentView.transform = CGAffineTransformMakeScale(0.95, 0.95)
        }, completion: lambda { |completed|
          UIView.animateWithDuration(0.11, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
            cell.contentView.transform = CGAffineTransformMakeScale(1.03, 1.03)
          }, completion: lambda { |completed|
            UIView.animateWithDuration(0.11, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
              cell.contentView.transform = CGAffineTransformIdentity
            }, completion: nil)
          })
        })
      })
    })


    UIView.animateWithDuration(0.3, delay:0.0, usingSpringWithDamping:0.75, initialSpringVelocity:0.8, options:UIViewAnimationOptionCurveLinear, animations: lambda {cell.contentView.transform = CGAffineTransformIdentity}, completion: nil)
  end

  def translatedAndScaledTransformUsingViewRect(view_rect, from_rect)
    scales = CGSizeMake(view_rect.size.width / from_rect.size.width, view_rect.size.height / from_rect.size.height)
    offset = CGPointMake(CGRectGetMidX(view_rect) - CGRectGetMidX(from_rect), CGRectGetMidY(view_rect) - CGRectGetMidY(from_rect))

    CGAffineTransformMake(scales.width, 0, 0, scales.height, offset.x, offset.y)
  end

  def update_invite_button
    @start_button.enabled = true
    @start_button.setBackgroundColor @active_button_color

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
    elsif @selected_driver.length > 3
      @start_button.enabled = false
      @start_button.setBackgroundColor @inactive_button_color
    end
  end

  def do_invite
    return if @selected_driver.length == 0

    LoadingView.show

    params = {
      params: {
        api_key: current_user.api_key
      }
    }

    cup = Cup.new
    cup.host_user_id = current_user.id

    self.saved_item_count = 0
    cup.save_remote(params) do |new_cup|
      @selected_driver.each do |user|
        cup_member = CupMember.new({ cup_id: new_cup.id, user_id: user.id, state: 'invited'})
        cup_member.save_remote(params) do
          self.saved_item_count += 1

          if saved_item_count == @selected_driver.length
            LoadingView.hide

            cup_view_controller = CupViewController.alloc.initWithStyle UITableViewStyleGrouped
            nvc = UINavigationController.alloc.initWithRootViewController cup_view_controller

            presentViewController(nvc, animated:true, completion:nil)
            cup_view_controller.cup = new_cup
          end
        end
      end
    end
  end
end