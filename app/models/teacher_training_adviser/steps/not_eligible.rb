module TeacherTrainingAdviser::Steps
  class NotEligible < GITWizard::Step
    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      # don't proceed if a returning teacher
      !other_step(:returning_teacher).returning_to_teaching
    end

    def title_attribute
      :title
    end

    def skip_title_suffix?
      true
    end
  end
end
