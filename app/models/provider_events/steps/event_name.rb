module ProviderEvents
  module Steps
    class EventName < ::GITWizard::Step
      include FunnelTitle
      include SanitiseField

      attribute :event_name
      validates :event_name, presence: true, length: { maximum: 200 }

      before_validation -> { sanitise_field :event_name }
    end
  end
end
