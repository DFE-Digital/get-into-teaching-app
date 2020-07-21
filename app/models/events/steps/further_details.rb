module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      SUBSCRIBE_OPTIONS = [["Yes", true], ["No", false]].freeze

      attribute :event_id
      attribute :privacy_policy, :boolean
      attribute :future_events, :boolean
      attribute :mailing_list, :boolean
      attribute :address_postcode

      validates :event_id, presence: true
      validates :privacy_policy, presence: true, acceptance: true
      validates :future_events, inclusion: [true, false]
      validates :mailing_list, inclusion: [true, false]
      validates :address_postcode, postcode: { allow_blank: true }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.presence
      end

      before_validation if: :already_subscribed_to_events? do
        self.future_events = true
      end

      before_validation if: :already_subscribed_to_mailing_list? do
        self.mailing_list = true
      end

      def save        
        if valid?
          # TODO: ensure this is the policy we display to the user
          accepted_policy = GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
          @store["accepted_policy_id"] = accepted_policy.id
          @store["subscribe_to_events"] = self.future_events == true
          @store["subscribe_to_mailing_list"] = self.mailing_list == true
        end

        super
      end

      def subscribe_options
        SUBSCRIBE_OPTIONS
      end

      def already_subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end

      def already_subscribed_to_events?
        @store["already_subscribed_to_events"]
      end
    end
  end
end
