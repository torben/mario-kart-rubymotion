class Vehicle < RPModel
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns name:         :string,
          image_url:    :string,
          size:         :string,
          vehicle_type: :string,
          lastSyncedAt: :time

  belongs_to :user

  class << self
    def url
      "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/vehicles"
    end

    def wrapper
      @wrapper ||= {
        fields: {
          id:           :id,
          name:         :name,
          image_url:    :image_url,
          vehicle_type: :vehicle_type,
          size:         :size
        },
        relations: [:users]
      }
    end
  end
end