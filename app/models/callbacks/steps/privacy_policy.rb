module Callbacks
  module Steps
    class PrivacyPolicy < ::GITWizard::Step
      attribute :accept_privacy_policy, :boolean
      attribute :accepted_policy_id

      validates :accept_privacy_policy, acceptance: true, allow_nil: false

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end
    end
  end
end
