module TeacherTrainingAdviser::Steps
  class StageInterestedTeaching < GITWizard::Step
    extend ApiOptions

    attribute :preferred_education_phase_id, :integer

    validates :preferred_education_phase_id, pick_list_items: { method: :get_candidate_preferred_education_phases }

    OPTIONS = { secondary: 222_750_001, primary: 222_750_000 }.freeze

    include FunnelTitle

    def reviewable_answers
      super.tap do |answers|
        answers["preferred_education_phase_id"] = OPTIONS.key(preferred_education_phase_id).to_s.capitalize
      end
    end

    def interested_in_primary?
      preferred_education_phase_id == OPTIONS[:primary]
    end

    def skipped?
      other_step(:degree_country).another_country?
    end
  end
end
