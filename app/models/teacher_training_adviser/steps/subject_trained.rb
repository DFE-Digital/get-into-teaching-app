module TeacherTrainingAdviser::Steps
  class SubjectTrained < GITWizard::Step
    # NB: for convenience, we are storing the response for "what subject did you train to teach"
    # in the same CRM field we use for "what subject did you previously teach".

    attribute :subject_taught_id, :string

    validates :subject_taught_id, lookup_items: { method: :get_teaching_subjects }

    def self.options
      Crm::TeachingSubject.all_without_primary
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      has_paid_experience_in_uk = other_step(:paid_teaching_experience_in_uk).has_paid_experience_in_uk
      train_to_teach_in_uk = other_step(:train_to_teach_in_uk).train_to_teach_in_uk
      stage_trained_primary = other_step(:stage_trained).stage_taught_primary?

      !returning_teacher || has_paid_experience_in_uk || !train_to_teach_in_uk || stage_trained_primary
    end

    def reviewable_answers
      super.tap do |answers|
        answers["subject_taught_id"] = Crm::TeachingSubject.lookup_by_uuid(subject_taught_id)
      end
    end

    def title
      "subject trained to teach"
    end
  end
end
