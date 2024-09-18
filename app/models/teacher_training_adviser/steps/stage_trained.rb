module TeacherTrainingAdviser::Steps
  class StageTrained < GITWizard::Step
    extend ApiOptions
    # NB: for convenience, we are storing the response for "what stage did you train to teach"
    # in the same CRM field we use for "what stage did you previously teach".

    attribute :stage_taught_id, :integer

    validates :stage_taught_id, pick_list_items: { method: :get_candidate_preferred_education_phases }

    OPTIONS = { primary: 222_750_000, secondary: 222_750_001 }.freeze

    def reviewable_answers
      super.tap do |answers|
        answers["stage_taught_id"] = OPTIONS.key(stage_taught_id).to_s.capitalize
      end
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      has_paid_experience_in_uk = other_step(:paid_teaching_experience_in_uk).has_paid_experience_in_uk
      train_to_teach_in_uk = other_step(:train_to_teach_in_uk).train_to_teach_in_uk

      !returning_teacher || has_paid_experience_in_uk || !train_to_teach_in_uk
    end

    def returning_teacher?
      other_step(:returning_teacher).returning_to_teaching
    end

    def stage_taught_primary?
      stage_taught_id == OPTIONS[:primary]
    end
  end
end
