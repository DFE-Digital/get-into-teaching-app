module TeacherTrainingAdviser::Steps
  class QualificationRequired < GITWizard::Step
    def can_proceed?
      false
    end

    def skipped?
      retake_gcse_maths_english_step = other_step(:retake_gcse_maths_english)
      retake_gcse_science_step = other_step(:retake_gcse_science)
      retake_gcse_maths_english_skipped = retake_gcse_maths_english_step.skipped?
      retake_gcse_science_skipped = retake_gcse_science_step.skipped?
      planning_to_retake_gcse_maths_and_english_id = retake_gcse_maths_english_step.planning_to_retake_gcse_maths_and_english_id
      planning_to_retake_gcse_science_id = retake_gcse_science_step.planning_to_retake_gcse_science_id
      retaking_gcse_maths_english = planning_to_retake_gcse_maths_and_english_id != TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish::OPTIONS["No"]
      retaking_gcse_science = planning_to_retake_gcse_science_id != TeacherTrainingAdviser::Steps::RetakeGcseScience::OPTIONS["No"]

      (retake_gcse_maths_english_skipped || retaking_gcse_maths_english) &&
        (retake_gcse_science_skipped || retaking_gcse_science)
    end
  end
end
