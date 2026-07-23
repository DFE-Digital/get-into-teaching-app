module ProviderEvents
  module Steps
    class EventName < ::GITWizard::Step
      include FunnelTitle

      attribute :event_name
      validates :event_name, presence: true, length: { maximum: 200 }
    end
  end
end
