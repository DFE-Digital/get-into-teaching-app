module TeacherTrainingAdviser
  module Steps
    class LifeStage < ::GITWizard::Step
      attribute :situation, :integer
      validates :situation,
                presence: true,
                inclusion: { in: :situation_ids }

      include FunnelTitle

      def skipped?
        other_step(:returning_teacher).returning_to_teaching ||
          other_step(:degree_country).another_country?
      end

      def situations
        @situations ||=
          if other_step(:degree_status).has_degree?
            PickListItemsApiPresenter.new.get_candidate_situations_for_tta_graduate
          else
            PickListItemsApiPresenter.new.get_candidate_situations_for_tta_undergraduate
          end
      end

      def situation_ids
        situations.map { |option| option.id.to_i }
      end

      def reviewable_answers
        {
          "situation" => situation ? I18n.t("helpers.answer.teacher_training_adviser_steps.life_stage.situation.#{situation}", **Value.data) : nil,
        }
      end
    end
  end
end
