module TeacherTrainingAdviser::Steps
  class UkCallback < GITWizard::Step
    extend CallbackBookingQuotas

    attribute :address_telephone, :string
    attribute :phone_call_scheduled_at, :datetime
    attribute :callback_offered, :boolean

    validates :address_telephone, telephone: true, presence: true, if: :callback_offered
    validates :phone_call_scheduled_at, presence: true, if: :callback_offered

    before_validation if: :address_telephone do
      self.address_telephone = address_telephone.to_s.strip.presence
    end

    def self.contains_personal_details?
      true
    end

    def reviewable_answers
      return {} unless callback_offered

      {
        "address_telephone" => address_telephone,
        "callback_date" => phone_call_scheduled_at&.to_date,
        "callback_time" => phone_call_scheduled_at&.to_time,
      }
    end

    def export
      super.except("callback_offered")
    end

    def skipped?
      uk_address_skipped = other_step(:uk_address).skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_skipped = have_a_degree_step.skipped?
      equivalent_degree = have_a_degree_step.degree_options == HaveADegree::DEGREE_OPTIONS[:equivalent]

      uk_address_skipped || have_a_degree_skipped || !equivalent_degree
    end
  end
end
