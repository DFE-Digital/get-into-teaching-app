module TeacherTrainingAdviser::Steps
  class UkTelephone < GITWizard::Step
    attribute :address_telephone, :string

    validates :address_telephone, telephone: true, allow_blank: true

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

    def skipped?
      return true if super

      # TODO: Add additional logic to display/skip this step
      other_step(:uk_address).skipped?
    end

    def title_attribute
      :fieldset
    end
  end
end
