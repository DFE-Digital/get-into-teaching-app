module Events
  module Steps
    class PersonalisedUpdates < ::Wizard::Step
      attribute :degree_status_id, :integer
      attribute :consideration_journey_stage_id, :integer
      attribute :address_postcode
      attribute :preferred_teaching_subject_id

      validates :degree_status_id, inclusion: { in: :degree_status_option_ids }
      validates :consideration_journey_stage_id, inclusion: { in: :journey_stage_option_ids }
      validates :address_postcode, postcode: { allow_blank: true }
      validates :preferred_teaching_subject_id, inclusion: { in: :teaching_subject_option_ids }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.presence
      end

      def skipped?
        !@store["subscribe_to_mailing_list"]
      end

      def degree_status_options
        [[1, "Undergraduate"]]
      end

      def degree_status_option_ids
        degree_status_options.map(&:first)
      end

      def journey_stage_options
        [[1, "Stage 1"]]
      end

      def journey_stage_option_ids
        journey_stage_options.map(&:first)
      end

      def teaching_subject_options
        [["fd11dc24-54ee-41b7-bf46-5f7e4d8926e5", "Maths"]]
      end

      def teaching_subject_option_ids
        teaching_subject_options.map(&:first)
      end
    end
  end
end
