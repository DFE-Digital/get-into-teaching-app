module MailingList
  module Steps
    class TeacherTraining < ::Wizard::Step
      attribute :consideration_journey_stage_id
      validates :consideration_journey_stage_id,
                presence: true,
                inclusion: { in: :consideration_journey_stage_ids, allow_nil: true }

      def consideration_journey_stages
        @consideration_journey_stages ||= query_consideration_journey_stages
      end

      def consideration_journey_stage_ids
        consideration_journey_stages.map(&:id)
      end

    private

      def query_consideration_journey_stages
        GetIntoTeachingApiClient::TypesApi.new.get_candidate_journey_stages
      end
    end
  end
end
