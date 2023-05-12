module TeacherTrainingAdviser::Steps
  class OverseasTimeZone < GITWizard::Step
    extend CallbackBookingQuotas

    attribute :address_telephone, :string
    attribute :time_zone, :string
    attribute :callback_offered, :boolean

    validates :address_telephone, telephone: { international: true }, presence: true, if: :callback_offered
    validates :time_zone, presence: true, if: :callback_offered

    before_validation if: :address_telephone do
      self.address_telephone = address_telephone.to_s.strip.presence
    end

    def self.contains_personal_details?
      true
    end

    def filtered_time_zones
      ActiveSupport::TimeZone.all.drop(1)
    end

    def reviewable_answers
      return {} unless callback_offered

      { "address_telephone" => address_telephone }.tap do |answers|
        answers["time_zone"] = time_zone if time_zone.present?
      end
    end

    def export
      super.except("callback_offered")
    end

    def address_telephone_value
      address_telephone || other_step(:overseas_country).dial_in_code
    end

    def skipped?
      overseas_country_skipped = other_step(:overseas_country).skipped?
      degree_options = other_step(:have_a_degree).degree_options
      equivalent_degree = degree_options == HaveADegree::DEGREE_OPTIONS[:equivalent]

      overseas_country_skipped || !equivalent_degree
    end
  end
end
