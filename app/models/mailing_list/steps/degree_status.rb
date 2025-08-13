module MailingList
  module Steps
    class DegreeStatus < ::GITWizard::Step
      HAS_DEGREE = 222_750_000
      DEGREE_IN_PROGRESS = 222_750_006
      NO_DEGREE = 222_750_004

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
                if: :degree_in_progress?

      validate :graduation_year_not_in_the_past, if: :degree_in_progress?
      validate :graduation_year_not_too_far_in_the_future, if: :degree_in_progress?

      delegate :magic_link_token_used?, to: :@wizard

      include FunnelTitle

      def degree_status_options
        @degree_status_options ||= query_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map { |option| option.id.to_i }
      end

      def has_degree?
        degree_status_id == HAS_DEGREE
      end

      def degree_in_progress?
        degree_status_id == DEGREE_IN_PROGRESS
      end

      def no_degree?
        degree_status_id == NO_DEGREE
      end

    private

      def query_degree_status
        PickListItemsApiPresenter.new.get_qualification_degree_status
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
