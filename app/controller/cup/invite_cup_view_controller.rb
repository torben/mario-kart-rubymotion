class InviteCupViewController < RPCollectionViewController
  attr_accessor :cup, :users, :saved_item_count

  def viewDidLoad
    super

    @users = []
    @selected_driver = []

    self.title = "Kollege Invite"
    # self.tableView.registerClass(InviteTableViewCell, forCellReuseIdentifier:"Cell")
    self.collectionView.backgroundColor = '#F0F0F0'.to_color
    self.collectionView.registerClass(InviteCollectionViewCell, forCellWithReuseIdentifier:"Cell")

    User.fetch(User.url) do |models|
      self.users = User.where(:id).ne(User.current_user.id).order(:nickname).all
      self.collectionView.reloadData
    end
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
      cell.selected = true
      # return if @selected_driver.length >= 3

      # cell.accessoryType = UITableViewCellAccessoryCheckmark
      @selected_driver.push user
    end

    wubbel(cell)

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
    #cell.contentView.transform = CGAffineTransformTranslate(translatedAndScaledTransformUsingViewRect(small_frame, end_frame), 0, 0)

    # UIView.animateWithDuration(0.46, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {

    UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
      cell.update_cell_selection
      cell.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)
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

  def do_invite
    return if @selected_driver.length == 0

    LoadingView.show

    params = {
      params: {
        api_key: User.current_user.api_key
      }
    }

    self.saved_item_count = 0
    @selected_driver.each do |user|
      cup_member = CupMember.new({ cup_id: cup.id, user_id: user.id, state: 'invited'})
      cup_member.save_remote(params) do
        self.saved_item_count += 1

        if saved_item_count == @selected_driver.length
          LoadingView.hide

          cup_view_controller = CupViewController.alloc.initWithStyle UITableViewStyleGrouped
          navigationController.pushViewController(cup_view_controller, animated: true)
          cup_view_controller.cup = cup
        end
      end
    end
  end
end