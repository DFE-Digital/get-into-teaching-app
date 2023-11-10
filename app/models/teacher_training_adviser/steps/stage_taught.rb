module TeacherTrainingAdviser::Steps
  class StageTaught < GITWizard::Step
    before_validation :primary_subject_taught, if: :previous_stage_primary?

    attribute :stage_taught, :string
    attribute :subject_taught_id, :string

    validates :stage_taught, inclusion: { in: %w[primary secondary] }
    validates :subject_taught_id, inclusion: { in: [Crm::TeachingSubject::PRIMARY] }, if: :previous_stage_primary?

    def previous_stage_primary?
      stage_taught == "primary"
    end

    def reviewable_answers
      super.tap do |answers|
        answers["stage_taught"] = stage_taught.humanize
        answers["subject_taught_id"] = Crm::TeachingSubject.lookup_by_uuid(subject_taught_id)
      end
    end

    def skipped?
      !other_step(:returning_teacher).returning_to_teaching
    end

  private

    def primary_subject_taught
      assign_attributes(subject_taught_id: Crm::TeachingSubject::PRIMARY)
    end
  end
end
