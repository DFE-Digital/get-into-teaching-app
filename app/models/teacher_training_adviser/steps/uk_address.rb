module TeacherTrainingAdviser::Steps
  class UkAddress < GITWizard::Step
    include NormalisePostcode
    attribute :address_postcode, :string

    validates :address_postcode, format: { with: /^([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})$/i, multiline: true }

    before_validation -> { normalise_postcode :address_postcode }

    include FunnelTitle

    def self.contains_personal_details?
      true
    end

    def skipped?
      other_step(:location).overseas? || other_step(:degree_country).another_country?
    end
  end
end
