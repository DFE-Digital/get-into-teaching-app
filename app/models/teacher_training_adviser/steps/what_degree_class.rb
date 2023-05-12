module TeacherTrainingAdviser::Steps
  class WhatDegreeClass < GITWizard::Step
    extend ApiOptions

    OMIT_GRADE_IDS = [
      222_750_004, # Third class or below
      222_750_005, # Unknown
    ].freeze

    attribute :uk_degree_grade_id, :integer

    def self.options
      generate_api_options(GetIntoTeachingApiClient::PickListItemsApi, :get_qualification_uk_degree_grades, OMIT_GRADE_IDS)
    end

    validates :uk_degree_grade_id, pick_list_items: { method: :get_qualification_uk_degree_grades }

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_skipped = have_a_degree_step.skipped?
      have_a_degree = have_a_degree_step.degree_options == HaveADegree::DEGREE_OPTIONS[:yes]
      studying_final_year = have_a_degree_step.degree_options == HaveADegree::DEGREE_OPTIONS[:studying] && other_step(:stage_of_degree).final_year?

      have_a_degree_skipped || (!have_a_degree && !studying_final_year)
    end

    def studying?
      other_step(:have_a_degree).studying?
    end

    def reviewable_answers
      super.tap do |answers|
        answers["uk_degree_grade_id"] = self.class.options.key(uk_degree_grade_id)
      end
    end
  end
end
