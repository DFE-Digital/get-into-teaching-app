module MailingList
  module Steps
    class TeacherTraining < ::GITWizard::Step
      HIGH_COMMITMENT = 222_750_003 # I’m very sure and think I’ll apply

      attribute :consideration_journey_stage_id, :integer
      validates :consideration_journey_stage_id,
                presence: true,
                inclusion: { in: :consideration_journey_stage_ids }

      include FunnelTitle

      def consideration_journey_stages
        @consideration_journey_stages ||= ::PickListItemsApiPresenter.new.get_candidate_journey_stages
      end

      def consideration_journey_stage_ids
        consideration_journey_stages.map { |option| option.id.to_i }
      end
    end
  end
end
