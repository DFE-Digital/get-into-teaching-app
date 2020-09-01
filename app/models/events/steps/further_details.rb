module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      SUBSCRIBE_OPTIONS = [["Yes", true], ["No", false]].freeze

      attribute :event_id
      attribute :privacy_policy, :boolean
      attribute :subscribe_to_mailing_list, :boolean
      attribute :accepted_policy_id

      validates :event_id, presence: true
      validates :privacy_policy, presence: true, acceptance: true
      validates :subscribe_to_mailing_list, inclusion: { in: :mailing_list_values }

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end

      def subscribe_options
        SUBSCRIBE_OPTIONS
      end

      def already_subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end

    private

      def mailing_list_values
        already_subscribed_to_mailing_list? ? [true, false, nil] : [true, false]
      end
    end
  end
end
