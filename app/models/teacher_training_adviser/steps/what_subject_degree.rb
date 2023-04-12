module TeacherTrainingAdviser::Steps
  class WhatSubjectDegree < GITWizard::Step
    extend ApiOptions

    OMIT_SUBJECT_IDS = [
      "bc68e0c1-7212-e911-a974-000d3a206976", # No Preference
    ].freeze

    attribute :degree_subject, :string

    validates :degree_subject, presence: true

    def self.options
      generate_api_options(GetIntoTeachingApiClient::LookupItemsApi, :get_teaching_subjects, OMIT_SUBJECT_IDS)
    end

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_skipped = have_a_degree_step.skipped?
      degree_options = have_a_degree_step.degree_options
      not_studying_or_have_a_degree = [
        HaveADegree::DEGREE_OPTIONS[:studying],
        HaveADegree::DEGREE_OPTIONS[:yes],
      ].none?(degree_options)

      have_a_degree_skipped || not_studying_or_have_a_degree
    end
  end
end
