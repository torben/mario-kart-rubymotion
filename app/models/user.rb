class User < RPModel
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns email:              :string,
          password:           :string,
          api_key:            :string,
          nickname:           :string,
          win_count:          :integer,
          avatar_url:         :string,
          drive_count:        :integer,
          total_points:       :integer,
          points_per_race:    :integer,
          last_character_id:  :integer,
          last_vehicle_id:    :integer,
          lastSyncedAt:       :time

  has_many :cups
  has_many :vehicles
  has_many :characters


  class << self
    def url
      "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/users"
    end

    def wrapper
      @wrapper ||= {
        fields: {
          id:                 :id,
          email:              :email,
          api_key:            :api_key,
          nickname:           :nickname,
          win_count:          :win_count,
          avatar_url:         :avatar_url,
          drive_count:        :drive_count,
          total_points:       :total_points,
          points_per_race:    :points_per_race,
          last_character_id:  :last_character_id,
          last_vehicle_id:    :last_vehicle_id
        },
        relations: [:cups, :vehicles, :characters]
      }
    end

    def user_signed_in?
      current_user.present?
    end

    def current_user
      if App::Persistence['currentUserToken'].present?
        User.where(:api_key).eq(App::Persistence['currentUserToken']).first
      end
    end

    def login(email, password, &block)
      payload = {
        user: {
          email: email,
          password: password
        }
      }

      BW::HTTP.post("#{url}/sign_in.json", {payload: payload}) do |response|
        if response.ok?
          puts response.body.to_str
          json = BW::JSON.parse(response.body.to_str)
          user_json = json["user"]

          user = User.where(:email).eq(user_json["email"]).first
          if user.present?
            user.attributes = json["user"].delete("id")
          else
            puts json["user"]
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
  end
end