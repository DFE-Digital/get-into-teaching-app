module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      include ActiveModel::Validations::Callbacks
      FUTURE_EVENT_OPTIONS = [["Yes", true], ["No", false]].freeze

      attribute :privacy_policy, :boolean
      attribute :future_events, :boolean
      attribute :postcode

      validates :privacy_policy, presence: true, acceptance: true
      validates :future_events, inclusion: [true, false]
      validates :postcode, postcode: { allow_blank: true }

      before_validation if: :postcode do
        self.postcode = postcode.to_s.strip
      end

      def future_event_options
        FUTURE_EVENT_OPTIONS
      end
    end
  end
end
