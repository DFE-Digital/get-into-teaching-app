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
                  message: "Enter your expected graduation year",
                },
                numericality: { only_integer: true },
                presence: { message: "Enter your expected graduation year" },
                if: :requires_graduation_year?

      validate :graduation_year_not_in_the_past, if: :requires_graduation_year?
      validate :graduation_year_not_too_far_in_the_future, if: :requires_graduation_year?

      delegate :magic_link_token_used?, to: :@wizard

      include FunnelTitle

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

      def graduation_year_not_in_the_past
        if graduation_year.present? && graduation_year < Time.current.year
          errors.add(:graduation_year, "Your expected graduation year cannot be in the past")
        end
      end

      def graduation_year_not_too_far_in_the_future
        if graduation_year.present? && graduation_year >= Time.current.year + 10
          errors.add(:graduation_year, "Your expected graduation year cannot be more than 10 years from now")
        end
      end
    end
  end
end
