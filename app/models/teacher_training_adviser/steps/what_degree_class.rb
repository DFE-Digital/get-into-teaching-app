module TeacherTrainingAdviser::Steps
  class WhatDegreeClass < GITWizard::Step
    extend ApiOptions

    OMIT_GRADE_IDS = [
      222_750_004, # Third class or below
      222_750_005, # Unknown
    ].freeze

    attribute :uk_degree_grade_id, :integer

    include FunnelTitle

    def self.options
      generate_api_options(GetIntoTeachingApiClient::PickListItemsApi, :get_qualification_uk_degree_grades, OMIT_GRADE_IDS)
    end

    validates :uk_degree_grade_id, pick_list_items: { method: :get_qualification_uk_degree_grades }

    def skipped?
      degree_status_step = other_step(:degree_status)

      degree_status_step.skipped? || (!degree_status_step.has_degree? && degree_status_step.studying_not_final_year?)
    end


    def degree_in_progress?
      other_step(:degree_status).degree_in_progress?
    end

    def reviewable_answers
      super.tap do |answers|
        answers["uk_degree_grade_id"] = self.class.options.key(uk_degree_grade_id)
      end
    end

    def title_attribute
      if other_step(:degree_status).degree_in_progress?
        "uk_degree_grade_id.studying"
      else
        "uk_degree_grade_id.graduated"
      end
    end
  end
end
