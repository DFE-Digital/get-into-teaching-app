module TeacherTrainingAdviser::Steps
  class SubjectInterestedTeaching < GITWizard::Step
    extend ApiOptions

    attribute :preferred_teaching_subject_id, :string

    validates :preferred_teaching_subject_id, lookup_items: { method: :get_teaching_subjects }

    OMIT_SUBJECT_IDS = [
      "bc2655a1-2afa-e811-a981-000d3a276620", # Other
      "bc68e0c1-7212-e911-a974-000d3a206976", # No Preference
      "b02655a1-2afa-e811-a981-000d3a276620", # Primary
    ].freeze

    def self.options
      generate_api_options(GetIntoTeachingApiClient::LookupItemsApi, :get_teaching_subjects, OMIT_SUBJECT_IDS)
    end

    def reviewable_answers
      super.tap do |answers|
        answers["preferred_teaching_subject_id"] = self.class.options.key(preferred_teaching_subject_id)
      end
    end

    def skipped?
      have_a_degree_skipped = other_step(:have_a_degree).skipped?
      preferred_education_phase_id = other_step(:stage_interested_teaching).preferred_education_phase_id
      phase_is_not_secondary = preferred_education_phase_id != StageInterestedTeaching::OPTIONS[:secondary]

      have_a_degree_skipped || phase_is_not_secondary
    end
  end
end
