module ProviderEvents
  module Steps
    class TargetAudience < ::GITWizard::Step
      include FunnelTitle

      attribute :target_audience
      validates :target_audience, presence: true, length: { maximum: 500 }
    end
  end
end
