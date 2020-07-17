module MailingList
  module Steps
    class Name < ::Wizard::Step
      include ::Wizard::IssueVerificationCode

      attribute :first_name
      attribute :last_name
      attribute :email
      attribute :describe_yourself_option_id

      validates :email, presence: true, email_format: true
      validates :first_name, presence: true
      validates :last_name, presence: true
      validates :describe_yourself_option_id,
                presence: true,
                inclusion: { in: :describe_yourself_option_ids, allow_nil: true }

      before_validation if: :email do
        self.email = email.to_s.strip
      end

      before_validation if: :first_name do
        self.first_name = first_name.to_s.strip
      end

      before_validation if: :last_name do
        self.last_name = last_name.to_s.strip
      end

      def describe_yourself_options
        @describe_yourself_options ||= query_decribe_yourself_options
      end

      def describe_yourself_option_ids
        describe_yourself_options.map(&:id)
      end

    private

      def query_decribe_yourself_options
        GetIntoTeachingApiClient::TypesApi.new.get_candidate_describe_yourself_options
      end
    end
  end
end
