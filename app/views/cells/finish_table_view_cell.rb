class FinishTableViewCell < UITableViewCell
  attr_accessor :input_field

  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super

    setup_view

    self
  end

  def setup_view
    @input_field = FinishTextField.alloc.initWithFrame [[self.width - 16 - 30, 3], [45, 38]]
    @input_field.clearsOnBeginEditing = true
    @input_field.keyboardType = UIKeyboardTypeNumbersAndPunctuation

    addSubview @input_field
  end
end