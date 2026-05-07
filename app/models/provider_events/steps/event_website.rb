module ProviderEvents
  module Steps
    class EventWebsite < ::GITWizard::Step
      include FunnelTitle

      attribute :event_website
      validates :event_website, presence: false
    end
  end
end
