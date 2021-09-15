module Events
  module Steps
    class PersonalisedUpdates < ::DFEWizard::Step
      attribute :degree_status_id, :integer
      attribute :consideration_journey_stage_id, :integer
      attribute :address_postcode
      attribute :preferred_teaching_subject_id

      validates :degree_status_id, inclusion: { in: :degree_status_option_ids }
      validates :consideration_journey_stage_id, inclusion: { in: :journey_stage_option_ids }
      validates :address_postcode, postcode: { allow_blank: true }
      validates :preferred_teaching_subject_id, inclusion: { in: :teaching_subject_option_ids }

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
        @degree_status_options ||=
          GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map(&:id).map(&:to_i)
      end

      def journey_stage_options
        @journey_stage_options ||=
          GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_journey_stages
      end

      def journey_stage_option_ids
        journey_stage_options.map(&:id).map(&:to_i)
      end

      def teaching_subject_options
        @teaching_subject_options ||=
          GetIntoTeachingApiClient::LookupItemsApi.new.get_teaching_subjects.reject do |type|
            GetIntoTeachingApiClient::Constants::IGNORED_PREFERRED_TEACHING_SUBJECTS.values.include?(type.id)
          end
      end

      def teaching_subject_option_ids
        teaching_subject_options.map(&:id)
      end

    private

      def postcode_in_crm
        @store.crm(:address_postcode)
      end
    end
  end
end
