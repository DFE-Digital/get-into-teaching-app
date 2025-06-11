module TeacherTrainingAdviser::Steps
  class NotEligible < GITWizard::Step

    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      returning_teacher = other_step(:returning_teacher).returning_to_teaching
      has_paid_experience_in_uk = other_step(:paid_teaching_experience_in_uk).has_paid_experience_in_uk
      train_to_teach_in_uk = other_step(:train_to_teach_in_uk).train_to_teach_in_uk

      !returning_teacher || has_paid_experience_in_uk || train_to_teach_in_uk
    end

    def title_attribute
      :title
    end

    def skip_title_suffix?
      true
    end
  end
end
