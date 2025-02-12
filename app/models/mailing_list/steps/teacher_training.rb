module MailingList
  module Steps
    class TeacherTraining < ::GITWizard::Step
      PICKLIST_ALLOW_IDS = [222750000, 222750003]

      attribute :consideration_journey_stage_id, :integer
      validates :consideration_journey_stage_id,
                presence: true,
                inclusion: { in: :consideration_journey_stage_ids }

      def consideration_journey_stages
        @consideration_journey_stages ||= query_consideration_journey_stages
      end

      def consideration_journey_stage_ids
        consideration_journey_stages.map { |option| option.id.to_i }
      end

    private

      def query_consideration_journey_stages
        GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_journey_stages.select do |option|
          PICKLIST_ALLOW_IDS.include?(option.id)
        end
      end
    end
  end
end
