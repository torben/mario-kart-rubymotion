module Modules
  module UserHelper
    def current_user
      @current_user ||= User.current_user
    end
  end
end