module TeacherTrainingAdviser::Steps
  class StageTaught < GITWizard::Step
    attribute :stage_taught, :string

    validates :stage_taught, inclusion: { in: %w[primary secondary] }

    def previous_stage_primary?
      stage_taught == "primary"
    end

    def skipped?
      !other_step(:returning_teacher).returning_to_teaching
    end
  end
end
