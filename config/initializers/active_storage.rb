class ActiveStorage::Attached::One
  JSON_OPTIONS = {
    only: [],
    methods: [
      # :filename,
      # :signed_id,
      :path
    ]
  }

  def serializable_hash(options = nil)
    super(JSON_OPTIONS)
  end
end

Rails.application.config.to_prepare do
  class ActiveStorage::Attachment < ActiveStorage::Record
    def path
      Rails.application.routes.url_helpers.rails_storage_proxy_url(self, only_path: true) # host: Rails.application.config.action_controller.asset_host)
    end
  end
end
