module TeacherTrainingAdviser::Steps
  class OverseasTelephone < GITWizard::Step
    attribute :address_telephone, :string

    validates :address_telephone, telephone: { international: true }, allow_blank: true

    before_validation if: :address_telephone do
      self.address_telephone = address_telephone.to_s.strip.presence
    end

    include FunnelTitle

    def self.contains_personal_details?
      true
    end

    def optional?
      true
    end

    def address_telephone_value
      address_telephone || other_step(:overseas_country).dial_in_code
    end

    def skipped?
      return true if super

      other_step(:overseas_country).skipped?
      # TODO: Add additional logic to display/skip this step
    end

    def title_attribute
      :fieldset
    end
  end
end
