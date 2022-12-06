module MailingList
  module Steps
    class Name < ::GITWizard::Step
      include ::GITWizard::IssueVerificationCode

      attribute :first_name
      attribute :last_name
      attribute :email
      attribute :channel_id, :integer
      attribute :sub_channel_id
      attribute :accepted_policy_id

      validates :email, presence: true, email_format: true
      validates :first_name, presence: true, length: { maximum: 256 }
      validates :last_name, presence: true, length: { maximum: 256 }

      before_validation if: :email do
        self.email = email.to_s.strip
      end

      before_validation if: :first_name do
        self.first_name = first_name.to_s.strip
      end

      before_validation if: :last_name do
        self.last_name = last_name.to_s.strip
      end

      def channel_ids
        query_channels.map { |channel| channel.id.to_i }
      end

      def export
        super.except("sub_channel_id").tap do |data|
          data["accepted_policy_id"] ||= latest_privacy_policy.id
        end
      end

      def save
        self.channel_id = nil if channel_invalid?

        super
      end

      def title
        nil
      end

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end

    private

      def channel_invalid?
        channel_id.present? && !channel_id.in?(channel_ids)
      end

      def query_channels
        @query_channels ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_mailing_list_subscription_channels
      end
    end
  end
end
