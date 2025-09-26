module TeacherTrainingAdviser::Steps
  class UkAddress < GITWizard::Step
    attribute :address_postcode, :string

    validates :address_postcode, format: { with: /^([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})$/i, multiline: true }

    before_validation :sanitize_input

    include FunnelTitle

    def self.contains_personal_details?
      true
    end

    def skipped?
      other_step(:uk_or_overseas).overseas? || other_step(:degree_country).another_country?
    end

  private

    def sanitize_input
      self.address_postcode = address_postcode.to_s.strip.presence if address_postcode
    end
  end
end
