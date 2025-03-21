module TeacherTrainingAdviser::Steps
  class SubjectInterestedTeaching < GITWizard::Step
    attribute :preferred_teaching_subject_id, :string

    validates :preferred_teaching_subject_id, lookup_items: { method: :get_teaching_subjects }

    def self.options
      Crm::TeachingSubject.all_without_primary
    end

    def reviewable_answers
      super.tap do |answers|
        answers["preferred_teaching_subject_id"] = Crm::TeachingSubject.lookup_by_uuid(preferred_teaching_subject_id)
      end
    end

    def skipped?
      have_a_degree_skipped = other_step(:have_a_degree).skipped?
      preferred_education_phase_id = other_step(:stage_interested_teaching).preferred_education_phase_id
      phase_is_not_secondary = preferred_education_phase_id != StageInterestedTeaching::OPTIONS[:secondary]

      have_a_degree_skipped || phase_is_not_secondary
    end

    def title
      "subject interested in teaching"
    end
  end
end
