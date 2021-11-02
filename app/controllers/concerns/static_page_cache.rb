module StaticPageCache
  extend ActiveSupport::Concern

  module ClassMethods
    def cache_actions(*actions)
      # This appears to be the only way to get `caches_page` to
      # run before the image/link processing that happens in ActionController.
      skip_after_action :process_images, :process_links
      caches_page *actions
      after_action :process_images, :process_links
    end
  end
end
