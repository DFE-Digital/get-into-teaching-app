module TeacherTrainingAdviser::Steps
  class NoDegree < GITWizard::Step
    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      degree_status_step = other_step(:degree_status)
      degree_status_step.skipped? || !degree_status_step.no_degree?
    end

    def title_attribute
      :title
    end

    def skip_title_suffix?
      true
    end
  end
end
