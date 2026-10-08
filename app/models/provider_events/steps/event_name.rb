module ProviderEvents
  module Steps
    class EventName < ::GITWizard::Step
      MAX_CHARS = 300

      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :event_name
      validates :event_name, presence: true, length: { maximum: MAX_CHARS }
      normalizes :event_name, with: ->(field) { field.to_s.squish.presence }
    end
  end
end
