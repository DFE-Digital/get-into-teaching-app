module TeacherTrainingAdviser::Steps
  class WhatDegreeClass < GITWizard::Step
    extend ApiOptions
    attribute :uk_degree_grade_id, :integer
    DEGREE_GRADE_2_2_OR_ABOVE = [222_750_000, 222_750_001, 222_750_002, 222_750_003].freeze # TODO: should we include / exclude "Not applicable" ?

    include FunnelTitle

    def self.options
      PickListItemsApiPresenter.new.get_qualification_uk_degree_grades
    end

    validates :uk_degree_grade_id, pick_list_items: { method: :get_qualification_uk_degree_grades }

    def skipped?
      degree_status_step = other_step(:degree_status)
      degree_country_step = other_step(:degree_country)

      degree_status_step.skipped? ||
        degree_country_step.another_country? ||
        (!degree_status_step.has_degree? && !degree_status_step.studying_final_year?)
    end

    def degree_in_progress?
      other_step(:degree_status).degree_in_progress?
    end

    def reviewable_answers
      {
        "uk_degree_grade_id" => uk_degree_grade_id ? I18n.t("helpers.answer.teacher_training_adviser_steps.what_degree_class.uk_degree_grade_id.#{uk_degree_grade_id}", **Value.data) : nil,
      }
    end

    def title_attribute
      if other_step(:degree_status).degree_in_progress?
        "uk_degree_grade_id.studying"
      else
        "uk_degree_grade_id.graduated"
      end
    end

    def degree_grade_2_2_or_above?
      DEGREE_GRADE_2_2_OR_ABOVE.include?(uk_degree_grade_id)
    end
  end
end
