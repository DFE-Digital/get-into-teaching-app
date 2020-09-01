module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      SUBSCRIBE_OPTIONS = [["Yes", true], ["No", false]].freeze

      attribute :event_id
      attribute :privacy_policy, :boolean
      attribute :mailing_list, :boolean
      attribute :accepted_policy_id

      validates :event_id, presence: true
      validates :privacy_policy, presence: true, acceptance: true
      validates :mailing_list, inclusion: [true, false]

      before_validation if: :already_subscribed_to_mailing_list? do
        self.mailing_list = true
      end

      def save
        if valid?
          @store["subscribe_to_mailing_list"] = mailing_list == true
        end

        super
      end

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end

      def subscribe_options
        SUBSCRIBE_OPTIONS
      end

      def already_subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end
    end
  end
end
