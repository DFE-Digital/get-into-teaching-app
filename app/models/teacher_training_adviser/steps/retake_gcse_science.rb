module TeacherTrainingAdviser::Steps
  class RetakeGcseScience < GITWizard::Step
    attribute :planning_to_retake_gcse_science_id, :integer

    validates :planning_to_retake_gcse_science_id, pick_list_items: { method: :get_candidate_retake_gcse_status }

    OPTIONS = Crm::BooleanType::ALL

    def reviewable_answers
      super.tap do |answers|
        answers["planning_to_retake_gcse_science_id"] =
          OPTIONS.key(planning_to_retake_gcse_science_id).to_s.capitalize
      end
    end

    def skipped?
      gcse_science_step = other_step(:gcse_science)
      gcse_science_skipped = gcse_science_step.skipped?
      has_gcse_science_id = gcse_science_step.has_gcse_science_id
      has_gcse_science = has_gcse_science_id != GcseMathsEnglish::OPTIONS["No"]

      gcse_science_skipped || has_gcse_science
    end
  end
end
