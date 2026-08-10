module ProviderEvents
  module Steps
    class EventName < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :event_name
      validates :event_name, presence: true, length: { maximum: 200 }
      normalizes :event_name, with: ->(field) { field.to_s.squish.presence }
    end
  end
end
