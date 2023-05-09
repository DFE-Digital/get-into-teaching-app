module TeacherTrainingAdviser::Steps
  class SubjectLikeToTeach < GITWizard::Step
    extend ApiOptions

    OMIT_SUBJECT_IDS = [
      "b02655a1-2afa-e811-a981-000d3a276620", # Primary
    ].freeze

    attribute :preferred_teaching_subject_id, :string

    validates :preferred_teaching_subject_id, lookup_items: { method: :get_teaching_subjects }

    def self.options
      generate_api_options(GetIntoTeachingApiClient::LookupItemsApi, :get_teaching_subjects, OMIT_SUBJECT_IDS)
    end

    def skipped?
      !other_step(:returning_teacher).returning_to_teaching
    end

    def reviewable_answers
      super.tap do |answers|
        answers["preferred_teaching_subject_id"] = self.class.options.key(preferred_teaching_subject_id)
      end
    end
  end
end
