module Helper
  module Authentication
    def current_user
      UserManager.instance.current_user
    end

    def params
      @params ||= {
        params: {
          api_key: current_user.try(:api_key)
        }
      }
    end
  end
end