module UserSettings
  module TextField
    def textFieldShouldBeginEditing(textField)
      true
    end

    def textFieldShouldReturn(textField)
      textField.resignFirstResponder

      false
    end

    def textField(textField, shouldChangeCharactersInRange:range, replacementString:string)
      value = textField.text.stringByReplacingCharactersInRange(range, withString:string)

      current_user.nickname = value

      true
    end
  end
end