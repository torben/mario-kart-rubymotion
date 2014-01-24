class UserManager
  def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def current_user
    return if App::Persistence['currentUserToken'].blank?

    @current_user ||= User.where(:api_key).eq(App::Persistence['currentUserToken']).first
  end

  def user_signed_in?
    current_user.present?
  end

  def login(email, password, &block)
    payload = {
      user: {
        email: email,
        password: password
      }
    }

    BW::HTTP.post("#{User.url}/sign_in.json", {payload: payload}) do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_str)
        user_json = json["user"]

        user = User.where(:email).eq(user_json["email"]).first
        if user.present?
          json["user"].delete("id")
          user.attributes = json["user"]
        else
          user = User.updateModels(json["user"])
        end

        user.save

        App::Persistence['currentUserToken'] = user.api_key

        if block.present?
          block.call(user)
        end

      elsif response.status_code.to_s =~ /40\d/
        App.alert("Login failed")
      else
        App.alert(response.error_message)
      end
    end
  end

  def logout
    @current_user = nil
    App::Persistence['currentUserToken'] = nil
  end
end