module Events
  module Steps
    class PersonalisedUpdates < ::GITWizard::Step
      GRADUATION_YEAR_DEPENDENT_OPTION_ID = 222_750_006

      attribute :degree_status_id, :integer
      attribute :consideration_journey_stage_id, :integer
      attribute :address_postcode
      attribute :preferred_teaching_subject_id
      attribute :graduation_year, :integer

      validates :degree_status_id, inclusion: { in: :degree_status_option_ids }
      validates :consideration_journey_stage_id, inclusion: { in: :journey_stage_option_ids }
      validates :address_postcode, postcode: { allow_blank: true }
      validates :preferred_teaching_subject_id, inclusion: { in: :teaching_subject_option_ids }
      validates :graduation_year,
                format: {
                  with: /\A\d{4}\z/,
                  message: "Tell us which year you will graduate",
                },
                numericality: { only_integer: true },
                presence: { message: "Tell us which year you will graduate" },
                if: :requires_graduation_year?

      validate :graduation_year_not_in_the_past, if: :requires_graduation_year?
      validate :graduation_year_not_too_far_in_the_future, if: :requires_graduation_year?

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.upcase.presence
      end

      def skipped?
        !@store["subscribe_to_mailing_list"]
      end

      def hide_postcode_field?
        postcode_in_crm.present?
      end

      def export
        super.tap do |hash|
          hash["address_postcode"] = postcode_in_crm if hide_postcode_field?
        end
      end

      def degree_status_options
        @degree_status_options ||= PickListItemsApiPresenter.new.get_qualification_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map(&:id).map(&:to_i)
      end

      def journey_stage_options
        @journey_stage_options ||= PickListItemsApiPresenter.new.get_candidate_journey_stages
      end

      def journey_stage_option_ids
        journey_stage_options.map(&:id).map(&:to_i)
      end

      def teaching_subject_options
        @teaching_subject_options ||= Crm::TeachingSubject.all
      end

      def teaching_subject_option_ids
        teaching_subject_options.map(&:id)
      end

    private

      def postcode_in_crm
        @store.preexisting(:address_postcode)
      end

      def requires_graduation_year?
        degree_status_id == GRADUATION_YEAR_DEPENDENT_OPTION_ID
      end

      def graduation_year_not_in_the_past
        if graduation_year.present? && graduation_year < Time.current.year
          errors.add(:graduation_year, "Enter the current year or a year in the future")
        end
      end

      def graduation_year_not_too_far_in_the_future
        if graduation_year.present? && graduation_year >= Time.current.year + 10
          errors.add(:graduation_year, "Enter a valid graduation year")
        end
      end
    end
  end
end
