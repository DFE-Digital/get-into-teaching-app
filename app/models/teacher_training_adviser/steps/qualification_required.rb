module TeacherTrainingAdviser::Steps
  class QualificationRequired < GITWizard::Step
    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      retake_gcse_maths_english_step = other_step(:retake_gcse_maths_english)
      degree_country_step = other_step(:degree_country)

      retake_gcse_maths_english_skipped = retake_gcse_maths_english_step.skipped?
      planning_to_retake_gcse_maths_and_english_id = retake_gcse_maths_english_step.planning_to_retake_gcse_maths_and_english_id

      retaking_gcse_maths_english = planning_to_retake_gcse_maths_and_english_id != TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish::OPTIONS["No"]

      (retake_gcse_maths_english_skipped || retaking_gcse_maths_english) || degree_country_step.another_country?
    end

    def title_attribute
      :title
    end

    def skip_title_suffix?
      true
    end
  end
end
