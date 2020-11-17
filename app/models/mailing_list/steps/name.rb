module MailingList
  module Steps
    class Name < ::DFEWizard::Step
      include ::Wizard::IssueVerificationCode

      attribute :first_name
      attribute :last_name
      attribute :email
      attribute :degree_status_id, :integer
      attribute :channel_id, :integer

      validates :email, presence: true, email_format: true
      validates :first_name, presence: true, length: { maximum: 256 }
      validates :last_name, presence: true, length: { maximum: 256 }
      validates :degree_status_id,
                presence: true,
                inclusion: { in: :degree_status_option_ids }
      validates :channel_id, inclusion: { in: :channel_ids, allow_nil: true }

      before_validation if: :email do
        self.email = email.to_s.strip
      end

      before_validation if: :first_name do
        self.first_name = first_name.to_s.strip
      end

      before_validation if: :last_name do
        self.last_name = last_name.to_s.strip
      end

      def degree_status_options
        @degree_status_options ||= [OpenStruct.new(id: nil, value: "Please select")] + query_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map { |option| option.id.to_i }
      end

      def channel_ids
        query_channels.map { |channel| channel.id.to_i }
      end

    private

      def query_degree_status
        GetIntoTeachingApiClient::TypesApi.new.get_qualification_degree_status
      end

      def query_channels
        @query_channels ||= GetIntoTeachingApiClient::TypesApi.new.get_candidate_mailing_list_subscription_channels
      end
    end
  end
end
