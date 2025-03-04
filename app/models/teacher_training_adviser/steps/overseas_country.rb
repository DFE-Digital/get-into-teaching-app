module TeacherTrainingAdviser::Steps
  class OverseasCountry < GITWizard::Step
    extend ApiOptions
    # overwrites UK default
    attribute :country_id, :string

    validates :country_id, lookup_items: { method: :get_countries }

    OMIT_COUNTRY_IDS = [
      "76f5c2e6-74f9-e811-a97a-000d3a2760f2", # Unknown
      "72f5c2e6-74f9-e811-a97a-000d3a2760f2", # United Kingdom
    ].freeze

    def self.options
      generate_api_options(GetIntoTeachingApiClient::LookupItemsApi, :get_countries, OMIT_COUNTRY_IDS)
    end

    def dial_in_code
      return nil if country_name.blank?

      codes = IsoCountryCodes.search_by_name(country_name)
      codes.first.calling[1..]
    rescue IsoCountryCodes::UnknownCodeError
      nil
    end

    def skipped?
      other_step(:uk_or_overseas).uk_or_overseas == UkOrOverseas::OPTIONS[:uk]
    end

    def reviewable_answers
      super.tap do |answers|
        answers["country_id"] = country_name
      end
    end

    def title
      "country"
    end

  private

    def country_name
      self.class.options.key(country_id)
    end
  end
end
