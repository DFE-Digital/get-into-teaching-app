module ProviderEvents
  module Steps
    class TargetAudience < ::GITWizard::Step
      include FunnelTitle

      attribute :target_audience
      validates :target_audience, presence: true

      def target_audiences
        [
          OpenStruct.new(id: 222_750_000, value: "Option 1"),
          OpenStruct.new(id: 222_750_001, value: "Option 2"),
        ]
      end
    end
  end
end
