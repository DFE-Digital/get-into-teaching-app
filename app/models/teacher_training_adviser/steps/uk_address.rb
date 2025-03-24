module TeacherTrainingAdviser::Steps
  class UkAddress < GITWizard::Step
    attribute :address_postcode, :string

    validates :address_postcode, format: { with: /^([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})$/i, multiline: true }

    before_validation :sanitize_input

    def self.contains_personal_details?
      true
    end

    def skipped?
      other_step(:uk_or_overseas).uk_or_overseas != UkOrOverseas::OPTIONS[:uk]
    end

    def title
      "postcode"
    end

  private

    def sanitize_input
      self.address_postcode = address_postcode.to_s.strip.presence if address_postcode
    end
  end
end
