module TeacherTrainingAdviser::Steps
  class SubjectTaught < GITWizard::Step
    extend ApiOptions

    OMIT_SUBJECT_IDS = [
      "bc68e0c1-7212-e911-a974-000d3a206976", # No Preference
    ].freeze

    attribute :subject_taught_id, :string

    validates :subject_taught_id, lookup_items: { method: :get_teaching_subjects }

    def self.options
      generate_api_options(GetIntoTeachingApiClient::LookupItemsApi, :get_teaching_subjects, OMIT_SUBJECT_IDS)
    end

    def skipped?
      !other_step(:returning_teacher).returning_to_teaching
    end

    def reviewable_answers
      super.tap do |answers|
        answers["subject_taught_id"] = self.class.options.key(subject_taught_id)
      end
    end
  end
end
