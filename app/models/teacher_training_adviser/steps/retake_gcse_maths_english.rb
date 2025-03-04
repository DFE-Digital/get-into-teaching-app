module TeacherTrainingAdviser::Steps
  class RetakeGcseMathsEnglish < GITWizard::Step
    attribute :planning_to_retake_gcse_maths_and_english_id, :integer

    validates :planning_to_retake_gcse_maths_and_english_id, pick_list_items: { method: :get_candidate_retake_gcse_status }

    OPTIONS = Crm::BooleanType::ALL

    def reviewable_answers
      super.tap do |answers|
        answers["planning_to_retake_gcse_maths_and_english_id"] =
          OPTIONS.key(planning_to_retake_gcse_maths_and_english_id).to_s.capitalize
      end
    end

    def skipped?
      gcse_maths_english_step = other_step(:gcse_maths_english)
      gcse_maths_english_skipped = gcse_maths_english_step.skipped?
      has_gcse_maths_and_english_id = gcse_maths_english_step.has_gcse_maths_and_english_id
      has_gcse_maths_english = has_gcse_maths_and_english_id != GcseMathsEnglish::OPTIONS["No"]

      gcse_maths_english_skipped || has_gcse_maths_english
    end

    def title
      "retake english and maths gcses"
    end
  end
end
