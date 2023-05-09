module TeacherTrainingAdviser::Steps
  class StageOfDegree < GITWizard::Step
    extend ApiOptions

    # overwrites session[:sign_up]["degree_status_id"]
    attribute :degree_status_id, :integer

    validates :degree_status_id, pick_list_items: { method: :get_qualification_degree_status }

    DEGREE_STATUS = {
      final_year: 222_750_001,
      second_year: 222_750_002,
      first_year: 222_750_003,
      other: 222_750_005,
    }.freeze

    NOT_FINAL_YEAR = DEGREE_STATUS.except(:final_year)

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      studying = have_a_degree_step.degree_options == HaveADegree::DEGREE_OPTIONS[:studying]
      have_a_degree_skipped = have_a_degree_step.skipped?

      have_a_degree_skipped || !studying
    end

    def reviewable_answers
      super.tap do |answers|
        answers["degree_status_id"] = self.class.options.key(degree_status_id)
      end
    end

    def final_year?
      degree_status_id == DEGREE_STATUS[:final_year]
    end

    def self.options
      generate_api_options(GetIntoTeachingApiClient::PickListItemsApi, :get_qualification_degree_status, nil, DEGREE_STATUS.values)
    end
  end
end
