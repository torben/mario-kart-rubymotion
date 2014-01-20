class CupMember < RPModel
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns cup_id:       :integer,
          user_id:      :integer,
          vehicle_id:   :integer,
          character_id: :integer,
          placement:    :integer,
          points:       :integer,
          state:        :string,
          lastSyncedAt: :time

  belongs_to :cup
  belongs_to :user
  belongs_to :vehicle
  belongs_to :character


  class << self
    def url
      "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/cup_members"
    end

    def wrapper
      @wrapper ||= {
        fields: {
          id:           :id,
          cup_id:       :cup_id,
          user_id:      :user_id,
          vehicle_id:   :vehicle_id,
          character_id: :character_id,
          placement:    :placement,
          state:        :state,
          points:       :points
        },
        relations: [:cup, :user, :vehicle, :character]
      }
    end
  end

  def url
    "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/cups/#{cup_id}/cup_members"
  end
end