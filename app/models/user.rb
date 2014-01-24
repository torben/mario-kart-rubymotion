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
  end
end