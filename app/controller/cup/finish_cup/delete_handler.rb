module FinishCup
  module DeleteHandler
    def start_deleting(gesture)
      touchPoint = gesture.locationInView(tableView)
      indexPath = tableView.indexPathForRowAtPoint(touchPoint)

      return if indexPath.blank?
      return if cup_members[indexPath.row].blank? || cup_members[indexPath.row].user.id == current_user.id

      cell = tableView.cellForRowAtIndexPath indexPath

      case gesture.state
      when UIGestureRecognizerStateBegan then start_delete cell
      when UIGestureRecognizerStateEnded then cancel_delete cell
      end
    end

    def start_delete(cell)
      return if cell.contentView.alpha == 0
      cancel_timer

      UIView.animateWithDuration(0.6, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        cell.contentView.alpha = 0.01
      }, completion: lambda { |completed|
        if completed
          cell.contentView.alpha = 0
          finish_delete(cell)
        end
      })
    end

    def cancel_delete(cell)
      return if cell.contentView.alpha == 0

      indexPath = tableView.indexPathForCell(cell)
      return if indexPath.blank?

      UIView.animateWithDuration(0.6, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        cell.contentView.alpha = cell_alpha_for(cup_members[indexPath.row])
      }, completion: lambda { |finished|
        reload_cup if finished
      })
    end

    def finish_delete(cell)
      if cell.contentView.alpha == 0.0
        indexPath = tableView.indexPathForCell(cell)
        return if indexPath.blank?

        LoadingView.show("Deleting")
        cup_members[indexPath.row].destroy_remote(params) do
          LoadingView.hide
          tableView.reloadData
          reload_cup
        end
      else
        cancel_delete
      end
    end
  end
end