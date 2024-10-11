module TeacherTrainingAdviser::Steps
  class TrainToTeachInUk < GITWizard::Step
    attribute :train_to_teach_in_uk, :boolean
    validates :train_to_teach_in_uk, inclusion: { in: [true, false] }

    def reviewable_answers
      super.tap do |answers|
        answers["train_to_teach_in_uk"] = train_to_teach_in_uk ? "Yes" : "No"
      end
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      has_paid_experience_in_uk = other_step(:paid_teaching_experience_in_uk).has_paid_experience_in_uk

      !returning_teacher || has_paid_experience_in_uk
    end
  end
end
