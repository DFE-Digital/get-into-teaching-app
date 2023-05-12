module TeacherTrainingAdviser::Steps
  class NoDegree < GITWizard::Step
    def can_proceed?
      false
    end

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_degree = have_a_degree_step.degree_options != HaveADegree::DEGREE_OPTIONS[:no]

      have_a_degree_step.skipped? || have_degree
    end
  end
end
