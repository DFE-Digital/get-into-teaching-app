module TeacherTrainingAdviser::Steps
  class GcseMathsEnglish < GITWizard::Step
    attribute :has_gcse_maths_and_english_id, :integer

    validates :has_gcse_maths_and_english_id, pick_list_items: { method: :get_candidate_retake_gcse_status }

    OPTIONS = Crm::BooleanType::ALL

    def reviewable_answers
      super.tap do |answers|
        answers["has_gcse_maths_and_english_id"] = OPTIONS.key(has_gcse_maths_and_english_id).to_s.capitalize
      end
    end

    def skipped?
      other_step(:what_degree_class).skipped?
    end
  end
end
