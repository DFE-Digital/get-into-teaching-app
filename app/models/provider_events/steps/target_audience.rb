module ProviderEvents
  module Steps
    class TargetAudience < ::GITWizard::Step
      include FunnelTitle

      attribute :target_audience
      validates :target_audience, presence: true

      def target_audiences
        [
          OpenStruct.new(id: 222750000, value: "Option 1"),
          OpenStruct.new(id: 222750001, value: "Option 2")
        ]
      end
    end
  end
end
