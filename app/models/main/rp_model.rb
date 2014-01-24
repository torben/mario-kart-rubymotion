class RPModel
  include MotionModelResource::ApiWrapper

  def self.fetch(site, params = {}, &block)
    params.merge!(payload_for_fetch)

    super(site, params, &block)
  end

  def self.payload_for_fetch
    current_user = UserManager.instance.current_user

    if current_user.present?
      return {
        payload: {
          api_key: current_user.api_key
        }
      }
    end

    {}
  end
end