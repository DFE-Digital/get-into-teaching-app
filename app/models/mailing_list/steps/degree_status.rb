module MailingList
  module Steps
    class DegreeStatus < ::GITWizard::Step
      GRADUATION_YEAR_DEPENDENT_OPTION_ID = 222_750_006

      attribute :degree_status_id, :integer
      attribute :graduation_year, :integer

      validates :degree_status_id,
                presence: { message: "Choose a degree option from the list" },
                inclusion: { in: :degree_status_option_ids }

      validates :graduation_year,
                format: {
                  with: /\A\d{4}\z/,
                  message: "Tell us which year you will graduate"
                },
                numericality: {
                  only_integer: true,
                  greater_than_or_equal_to: Time.current.year,
                  less_than_or_equal_to: Time.current.year + 10,
                  message: "Enter the current year or a year in the future"
                },
                presence: { message: "Tell us which year you will graduate" },
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
        PickListItemsApiPresenter.new.get_qualification_degree_status
      end

      def requires_graduation_year?
        degree_status_id == GRADUATION_YEAR_DEPENDENT_OPTION_ID
      end
    end
  end
end
