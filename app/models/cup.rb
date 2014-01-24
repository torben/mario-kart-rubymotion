class Cup < RPModel
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns host_user_id:       :integer,
          winning_user_id:    :integer,
          motor_class:        :string,
          com:                :string,
          items:              :string,
          num_tracks:         :integer,
          lastSyncedAt:       :time

  has_many :cup_members


  class << self
    def url
      "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/cups"
    end

    def wrapper
      @wrapper ||= {
        fields: {
          id:                 :id,
          host_user_id:       :host_user_id,
          user_id:            :host_user_id,
          winning_user_id:    :winning_user_id,
          motor_class:        :motor_class,
          com:                :com,
          items:              :items,
          num_tracks:         :num_tracks
        },
        relations: [:cup_members]
      }
    end
  end

  def host_user
    User.find host_user_id
  end

  def winning_user
    User.find winning_user_id
  end

  def hosting_member
    CupMember.where(:cup_id).eq(id).and(:user_id).eq(host_user_id).first
  end

  def invited_members
    members_with_state("invited")
  end

  def accepted_members
    members_with_state("accepted")
  end

  def members_with_state(state)
    CupMember.where(:cup_id).eq(id).and(:user_id).ne(host_user_id).and(:state).eq(state).all
  end
end