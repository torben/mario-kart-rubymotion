module Helper
  module Authentication
    def current_user
      UserManager.instance.current_user
    end
  end
end