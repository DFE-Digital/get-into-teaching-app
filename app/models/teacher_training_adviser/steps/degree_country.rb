module TeacherTrainingAdviser::Steps
  class DegreeCountry < GITWizard::Step
    include ApiOptions
    UK = "72f5c2e6-74f9-e811-a97a-000d3a2760f2"
    ANOTHER_COUNTRY = "6f9e7b81-e44d-f011-877a-00224886d23e"
    DEGREE = 222_750_000
    DEGREE_EQUIVALENT = 222_750_005

    attribute :degree_country_id, :string
    attribute :degree_type_id, :integer

    validates :degree_country_id, lookup_items: { method: :get_degree_countries }
    validates :degree_type_id, inclusion: { in: [DEGREE, DEGREE_EQUIVALENT] }

    include FunnelTitle

    def degree_country_id=(value)
      super
      set_degree_type if value
    end

    def options
      generate_api_options(GetIntoTeachingApiClient::LookupItemsApi, :get_degree_countries, [], [UK, ANOTHER_COUNTRY])
    end

    def reviewable_answers
      {
        "degree_country_id" => degree_country_id ? I18n.t("helpers.answer.teacher_training_adviser_steps.degree_country.degree_country_id.#{degree_country_id}", **Value.data) : nil,
      }
    end

    def skipped?
      other_step(:returning_teacher).returning_to_teaching
    end

    def another_country?
      degree_country_id == ANOTHER_COUNTRY
    end

    private

    def set_degree_type
      self.degree_type_id = another_country? ? DEGREE_EQUIVALENT : DEGREE
    end
  end
end
