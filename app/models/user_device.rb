class UserDevice < RPModel
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns user_id:      :integer,
          uuid:         :string,
          apn_token:    :string,
          os_version:   :string,
          app_version:  :string,
          retina:       :boolean,
          model:        :string,
          language:     :string,
          open_count:   :integer,
          created_at:   :time,
          updated_at:   :time,
          lastSyncedAt: :time

  belongs_to :user

  class << self
    def url
      "#{NSBundle.mainBundle.objectForInfoDictionaryKey('host')}/user_devices"
    end

    def wrapper
      @wrapper ||= {
        fields: {
          user_id:      :user_id,
          uuid:         :uuid,
          apn_token:    :apn_token,
          os_version:   :os_version,
          app_version:  :app_version,
          retina:       :retina,
          model:        :model,
          open_count:   :open_count,
          language:     :language,
          created_at:   :created_at,
          updated_at:   :updated_at
        },
        relations: [:user]
      }
    end

    def uuid
      return App::Persistence['uuid'] if App::Persistence['uuid'].present?

      App::Persistence['uuid'] = UIDevice.currentDevice.identifierForVendor.UUIDString #BubbleWrap.create_uuid
      App::Persistence['uuid']
    end

    def current_user_device
      where(:uuid).eq(uuid).first
    end
  end

  def url
    url = "#{App.info_plist['host']}/user_devices"
    url += "/#{uuid}" unless new_record?

    url
  end

  def remote_save(options = {}, &block)
    default_options = if new_record?
      {
        params: {
          id: self.class.uuid
        }
      }
    else
      {}
    end
    options.merge!(default_options)

    if UserManager.instance.current_user.present?
      options.merge!(
        {
          params: {
            api_key: UserManager.instance.current_user.api_key
          }
        }
      )
    end

    action = if new_record?
      "create"
    elsif self.id.present?
      "update"
    else
      raise MotionModelResource::ActionNotImplemented.new "Action ist not implemented for #{self.class.name}!"
    end

    user_device = self
    requestBlock = Proc.new do |response|
      if response.ok? && response.body.present?
        json = BW::JSON.parse(response.body.to_str)

        user_device.wrap(json)
        user_device.lastSyncAt = Time.now if user_device.respond_to?(:lastSyncAt)
        user_device.save
      else
        user_device = nil
      end

      UserDevice.serialize_to_file('user_devices.dat')

      block.call if block.present? && block.respond_to?(:call)
    end

    hash = buildHashFromModel(self.class.name.underscore, self)
    hash.merge!(options[:params]) if options[:params].present?

    case action
    when "create"
      BW::HTTP.post(self.try(:url) || self.class.url, {payload: hash}, &requestBlock)
    when "update"
      BW::HTTP.put(self.try(:url) || "#{self.class.url}/#{model.id}", {payload: hash}, &requestBlock)
    end
  end
end