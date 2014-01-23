class LoginViewController < RPViewController
  def viewDidLoad
    super

    self.title = "Login"

    @headlineLabel = RPLabel.new
    @headlineLabel.text = "Bitte einloggen"

    @emailField = RPTextField.new
    @emailField.keyboardType = UIKeyboardTypeEmailAddress
    @emailField.delegate = self
    @emailField.tag = 1
    @emailField.placeholder = "E-Mail"
    @emailField.text = ""

    @passwordField = RPTextField.new
    @passwordField.secureTextEntry = true
    @passwordField.delegate = self
    @passwordField.tag = 2
    @passwordField.placeholder = "Passwort"
    @passwordField.text = ""

    @loginButton = RPButton.buttonWithType(UIButtonTypeCustom)
    @loginButton.setTitle("Einloggen", forState:UIControlStateNormal)
    @loginButton.addTarget(self, action:"submitForm", forControlEvents:UIControlEventTouchUpInside)

    view.backgroundColor = UIColor.whiteColor
    view.addSubviews @headlineLabel, @emailField, @passwordField, @loginButton
  end

  def viewDidLayoutSubviews
    padding = 10
    w = view.width - (padding * 2)
    h = 20
    y = 70

    @headlineLabel.frame = [[padding, y], [w, 30]]
    @headlineLabel.fontSize = 24
    y += @headlineLabel.height + padding

    @emailField.frame = [[padding, y], [w, h]]
    y += @emailField.height + padding

    @passwordField.frame = [[padding, y], [w, h]]
    y += @passwordField.height + padding

    @loginButton.frame = [[padding, y], [w, h]]
    y += @loginButton.height + padding
  end

  def textFieldShouldReturn(textField)
    nextTag = textField.tag + 1
    nextResponder = self.view.viewWithTag(nextTag)
    if nextResponder
      nextResponder.becomeFirstResponder
    else
      textField.resignFirstResponder

      submitForm
    end

    false
  end

  def submitForm
    if @emailField.text.present? && @passwordField.text.present?
      User.login(@emailField.text, @passwordField.text) do |user|
        App.window.rootViewController = MenuViewController.new
      end
    end
  end
end