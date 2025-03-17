module MailingList
  module Steps
    class DegreeStatus < ::GITWizard::Step
      GRADUATION_YEAR_DEPENDENT_OPTION_ID = 222_750_003

      attribute :degree_status_id, :integer
      attribute :graduation_year, :integer

      validates :degree_status_id,
                presence: true,
                inclusion: { in: :degree_status_option_ids }

      validates :graduation_year,
                numericality: {
                  only_integer: true,
                  greater_than_or_equal_to: Time.current.year,
                  less_than_or_equal_to: Time.current.year + 10,
                },
                format: { with: /\A\d{4}\z/, message: "must be a four-digit year" },
                presence: true,
                if: :requires_graduation_year?

      delegate :magic_link_token_used?, to: :@wizard

      def degree_status_options
        @degree_status_options ||= query_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map { |option| option.id.to_i }
      end

    private

      def query_degree_status
        GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status
      end

      def requires_graduation_year?
        degree_status_id == GRADUATION_YEAR_DEPENDENT_OPTION_ID
      end
    end
  end
end
