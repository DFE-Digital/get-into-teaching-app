module TeacherTrainingAdviser::Steps
  class SubjectTaught < GITWizard::Step
    attribute :subject_taught_id, :string

    validates :subject_taught_id, lookup_items: { method: :get_teaching_subjects }

    def self.options
      Crm::TeachingSubject.all_without_primary
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      has_paid_experience_in_uk = other_step(:paid_teaching_experience_in_uk).has_paid_experience_in_uk
      stage_taught_primary = other_step(:stage_taught).stage_taught_primary?

      !returning_teacher || !has_paid_experience_in_uk || stage_taught_primary
    end

    def reviewable_answers
      super.tap do |answers|
        answers["subject_taught_id"] = Crm::TeachingSubject.lookup_by_uuid(subject_taught_id)
      end
    end
  end
end
