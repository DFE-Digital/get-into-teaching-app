module ProviderEvents
  module Steps
    class EventWebsite < ::GITWizard::Step
      include FunnelTitle

      attribute :event_website
      validates :event_website, presence: true, length: { maximum: 300 }, url: { no_local: true }
    end
  end
end
