module TeacherTrainingAdviser::Steps
  class HasTeacherId < GITWizard::Step
    attribute :has_id, :boolean

    validates :has_id, inclusion: { in: [true, false] }

    def reviewable_answers
      super.tap do |answers|
        answers["has_id"] = has_id ? "Yes" : "No"
      end
    end

    def skipped?
      teacher_id_prefilled = @store.preexisting(:teacher_id)
      returning_teacher = other_step(:returning_teacher).returning_to_teaching

      !returning_teacher || teacher_id_prefilled
    end

    def title
      "have teacher reference number"
    end
  end
end
