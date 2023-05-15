module TeacherTrainingAdviser::Steps
  class GcseScience < GITWizard::Step
    attribute :has_gcse_science_id, :integer

    validates :has_gcse_science_id, pick_list_items: { method: :get_candidate_retake_gcse_status }

    OPTIONS = Crm::BooleanType::ALL

    def reviewable_answers
      super.tap do |answers|
        answers["has_gcse_science_id"] = OPTIONS.key(has_gcse_science_id).to_s.capitalize
      end
    end

    def skipped?
      gcse_maths_english_step = other_step(:gcse_maths_english)
      gcse_maths_english_skipped = gcse_maths_english_step.skipped?
      preferred_education_phase_id = other_step(:stage_interested_teaching).preferred_education_phase_id
      phase_is_secondary = preferred_education_phase_id == StageInterestedTeaching::OPTIONS[:secondary]
      has_gcse_maths_and_english_id = gcse_maths_english_step.has_gcse_maths_and_english_id
      planning_to_retake_gcse_maths_and_english_id = other_step(:retake_gcse_maths_english).planning_to_retake_gcse_maths_and_english_id
      no_gcse_maths_english = has_gcse_maths_and_english_id == GcseMathsEnglish::OPTIONS["No"] &&
        planning_to_retake_gcse_maths_and_english_id == RetakeGcseMathsEnglish::OPTIONS["No"]

      gcse_maths_english_skipped || no_gcse_maths_english || phase_is_secondary
    end
  end
end
