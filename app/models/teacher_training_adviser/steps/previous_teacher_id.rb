module TeacherTrainingAdviser::Steps
  class PreviousTeacherId < GITWizard::Step
    attribute :teacher_id, :string

    def optional?
      true
    end

    def skipped?
      return true if super

      has_teacher_id_step = other_step(:has_teacher_id)
      has_teacher_id_skipped = has_teacher_id_step.skipped?
      has_id = has_teacher_id_step.has_id

      has_teacher_id_skipped || !has_id
    end

    def title
      "teacher reference number"
    end
  end
end
