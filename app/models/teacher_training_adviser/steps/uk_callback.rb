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

    include FunnelTitle
    include CoerceToLondonTime

    def self.contains_personal_details?
      true
    end

    def reviewable_answers
      return {} unless callback_offered

      {
        "address_telephone" => address_telephone,
        "callback_date" => coerce_to_london_time(phone_call_scheduled_at)&.in_time_zone&.to_date,
        "callback_time" => coerce_to_london_time(phone_call_scheduled_at)&.in_time_zone&.to_time,
      }
    end

    def export
      super.except("callback_offered")
    end

    def skipped?
      live_overseas = other_step(:location).overseas?
      degree_status_skipped = other_step(:degree_status).skipped?
      uk_degree = other_step(:degree_country).uk?

      live_overseas || degree_status_skipped || uk_degree
    end

    def title_attribute
      :fieldset
    end
  end
end
