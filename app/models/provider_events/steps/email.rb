module ProviderEvents
  module Steps
    class Email < ::GITWizard::Step
      include FunnelTitle

      attribute :email
      validates :email, presence: true, email_format: true

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end
    end
  end
end
