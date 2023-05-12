module TeacherTrainingAdviser::Steps
  class PrimaryReturner < GITWizard::Step
    def can_proceed?
      false
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      preferred_education_phase_id = other_step(:stage_interested_teaching).preferred_education_phase_id
      phase_is_primary = preferred_education_phase_id == StageInterestedTeaching::OPTIONS[:primary]

      !(returning_teacher && phase_is_primary)
    end
  end
end
