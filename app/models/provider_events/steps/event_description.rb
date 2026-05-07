module ProviderEvents
  module Steps
    class EventDescription < ::GITWizard::Step
      include FunnelTitle

      attribute :event_description
      validates :event_description, presence: true, length: { maximum: 500 }
    end
  end
end
