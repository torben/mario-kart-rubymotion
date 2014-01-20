class Character < RPModel
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns name:         :string,
          avatar_url:   :string,
          size:         :string,
          lastSyncedAt: :time


  belongs_to :user

  class << self
    def url
      "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/characters"
    end

    def wrapper
      @wrapper ||= {
        fields: {
          id:         :id,
          name:       :name,
          avatar_url: :avatar_url,
          size:       :size
        },
        relations: [:users]
      }
    end
  end
end