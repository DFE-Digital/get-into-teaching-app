module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      FUTURE_EVENT_OPTIONS = [["Yes", true], ["No", false]].freeze

      attribute :event_id
      attribute :privacy_policy, :boolean
      attribute :future_events, :boolean
      attribute :address_postcode

      validates :event_id, presence: true
      validates :privacy_policy, presence: true, acceptance: true
      validates :future_events, inclusion: [true, false]
      validates :address_postcode, postcode: { allow_blank: true }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.presence
      end

      def save
        if valid?
          # TODO: ensure this is the policy we display to the user
          accepted_policy = GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
          @store["accepted_policy_id"] = accepted_policy.id
          @store["subscribe_to_events"] = future_events == true
        end

        super
      end

      def future_event_options
        FUTURE_EVENT_OPTIONS
      end
    end
  end
end
