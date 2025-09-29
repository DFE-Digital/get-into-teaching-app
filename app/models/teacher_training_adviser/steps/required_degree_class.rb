module TeacherTrainingAdviser::Steps
  class RequiredDegreeClass < GITWizard::Step
    include FunnelTitle

    def can_proceed?
      false
    end

    def skipped?
      degree_status_step = other_step(:degree_status)
      what_degree_class_step = other_step(:what_degree_class)
      degree_status_step.skipped? || degree_status_step.no_degree? || what_degree_class_step.degree_grade_2_2_or_above?
    end

    def title_attribute
      other_step(:degree_status).degree_in_progress? ? :title_predicted : :title_achieved
    end

    def skip_title_suffix?
      true
    end
  end
end
