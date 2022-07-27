module Events
  module Steps
    class FurtherDetails < ::GITWizard::Step
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

      def can_subscribe_to_mailing_list?
        !already_subscribed_to_mailing_list? && !already_subscribed_to_teacher_training_adviser?
      end

    private

      def mailing_list_values
        can_subscribe_to_mailing_list? ? [true, false] : [true, false, nil]
      end

      def already_subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end

      def already_subscribed_to_teacher_training_adviser?
        @store["already_subscribed_to_teacher_training_adviser"]
      end
    end
  end
end
