module TeacherTrainingAdviser::Steps
  class SubjectTaught < GITWizard::Step
    attribute :subject_taught_id, :string

    validates :subject_taught_id, lookup_items: { method: :get_teaching_subjects }

    def self.options
      Crm::TeachingSubject.all_hash
    end

    def skipped?
      !other_step(:returning_teacher).returning_to_teaching
    end

    def reviewable_answers
      super.tap do |answers|
        answers["subject_taught_id"] = Crm::TeachingSubject.lookup_by_uuid(subject_taught_id)
      end
    end
  end
end
