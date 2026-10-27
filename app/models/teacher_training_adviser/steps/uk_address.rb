module TeacherTrainingAdviser::Steps
  class UkAddress < GITWizard::Step
    include FunnelTitle
    include ActiveModel::Attributes::Normalization
    include ActiveModel::Dirty

    attribute :address_postcode

    validates :address_postcode, format: { with: /\A([A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})\z/i, multiline: true }

    normalizes :address_postcode, with: ->(field) { field.to_s.squish.upcase.presence }

    def self.contains_personal_details?
      true
    end

    def skipped?
      other_step(:location).overseas? || other_step(:degree_country).another_country?
    end
  end
end
