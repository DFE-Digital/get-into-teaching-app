module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      FUTURE_EVENT_OPTIONS = [["Yes", true], ["No", false]].freeze

      attribute :privacy_policy, :boolean
      attribute :future_events, :boolean
      attribute :address_postcode

      validates :privacy_policy, presence: true, acceptance: true
      validates :future_events, inclusion: [true, false]
      validates :address_postcode, postcode: { allow_blank: true }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip
      end

      def future_event_options
        FUTURE_EVENT_OPTIONS
      end
    end
  end
end
