module TeacherTrainingAdviser::Steps
  class NoDegree < GITWizard::Step
    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_step.skipped? || !have_a_degree_step.no_degree?
    end

    def title_attribute
      :title
    end

    def skip_title_suffix?
      true
    end
  end
end
