module TeacherTrainingAdviser::Steps
  class StageTaught < GITWizard::Step
    extend ApiOptions

    attribute :stage_taught_id, :integer

    validates :stage_taught_id, pick_list_items: { method: :get_candidate_preferred_education_phases } # TODO: change to get_candidate_stages_taught

    OPTIONS = { primary: 222_750_000, secondary: 222_750_001 }.freeze

    def reviewable_answers
      super.tap do |answers|
        answers["stage_taught_id"] = OPTIONS.key(stage_taught_id).to_s.capitalize
      end
    end

    def skipped?
      !returning_teacher?
    end

    def stage_taught_primary?
      stage_taught_id == OPTIONS[:primary]
    end

    def returning_teacher?
      other_step(:returning_teacher).returning_to_teaching
    end
  end
end
