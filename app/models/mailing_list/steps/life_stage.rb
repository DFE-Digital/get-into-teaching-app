module MailingList
  module Steps
    class LifeStage < ::GITWizard::Step
      QUALIFIED_TEACHER = 222_750_007

      attribute :situation, :integer
      validates :situation,
                presence: true,
                inclusion: { in: :situation_ids }

      include FunnelTitle

      def situations
        @situations ||=
          if other_step(:degree_status).has_degree?
            PickListItemsApiPresenter.new.get_candidate_situations_for_mailing_list_has_degree
          elsif other_step(:degree_status).degree_in_progress?
            PickListItemsApiPresenter.new.get_candidate_situations_for_mailing_list_degree_in_progress
          else
            PickListItemsApiPresenter.new.get_candidate_situations_for_mailing_list_no_degree
          end
      end

      def situation_ids
        situations.map { |option| option.id.to_i }
      end

      def qualified_teacher?
        situation == QUALIFIED_TEACHER
      end
    end
  end
end
