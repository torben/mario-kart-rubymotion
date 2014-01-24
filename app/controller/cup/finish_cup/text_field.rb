module FinishCup
  module TextField
    def textFieldShouldBeginEditing(textField)
      cancel_timer
      true
    end

    def textField(textField, shouldChangeCharactersInRange:range, replacementString:string)
      value = textField.text.stringByReplacingCharactersInRange(range, withString:string)

      if value.to_s.length <= 3
        #textField.text = value

        cup_member = cup_members[textField.indexPath.row]
        cup_member.points = value
      end
    end

    def textFieldShouldReturn(textField)
      row = textField.indexPath.row

      if row == row_count - 1
        textField.resignFirstResponder
      else
        next_row = row + 1
        if next_row == row_count
          next_row = 0
        end

        cell = tableView.cellForRowAtIndexPath(NSIndexPath.indexPathForRow(next_row, inSection:0))
        cell.input_field.becomeFirstResponder if cell
      end

      return false
    end
  end
end