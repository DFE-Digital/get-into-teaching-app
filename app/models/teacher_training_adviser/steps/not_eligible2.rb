module TeacherTrainingAdviser::Steps
  class NotEligible2 < GITWizard::Step
    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      # don't proceed if a returning teacher
      !other_step(:stage_interested_teaching).interested_in_primary?
    end

    def title_attribute
      :title
    end

    def skip_title_suffix?
      true
    end
  end
end
