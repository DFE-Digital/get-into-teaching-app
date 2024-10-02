module TeacherTrainingAdviser::Steps
  class PaidTeachingExperienceInUk < GITWizard::Step
    attribute :has_paid_experience_in_uk, :boolean
    validates :has_paid_experience_in_uk, inclusion: { in: [true, false] }

    def reviewable_answers
      super.tap do |answers|
        answers["has_paid_experience_in_uk"] = has_paid_experience_in_uk ? "Yes" : "No"
      end
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      !returning_teacher
    end
  end
end
