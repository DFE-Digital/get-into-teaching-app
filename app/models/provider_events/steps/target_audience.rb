module ProviderEvents
  module Steps
    class TargetAudience < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :target_audience
      validates :target_audience, presence: true, length: { maximum: 500 }
      normalizes :target_audience, with: ->(field) { field.to_s.squish.presence }
    end
  end
end
