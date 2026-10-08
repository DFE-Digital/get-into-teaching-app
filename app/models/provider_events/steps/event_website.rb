module ProviderEvents
  module Steps
    class EventWebsite < ::GITWizard::Step
      MAX_CHARS = 300

      include FunnelTitle

      attribute :event_website
      validates :event_website, presence: true, length: { maximum: MAX_CHARS }, url: { no_local: true }
    end
  end
end
