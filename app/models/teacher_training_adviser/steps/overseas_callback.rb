module TeacherTrainingAdviser::Steps
  class OverseasCallback < GITWizard::Step
    extend CallbackBookingQuotas

    attribute :phone_call_scheduled_at, :datetime

    validates :phone_call_scheduled_at, presence: true

    include FunnelTitle

    def reviewable_answers
      {
        "callback_date" => phone_call_scheduled_at&.to_date,
        "callback_time" => phone_call_scheduled_at&.to_time,
      }
    end

    def skipped?
      callback_not_offered = !other_step(:overseas_time_zone).callback_offered
      overseas_country_skipped = other_step(:overseas_country).skipped?
      degree_status_skipped = other_step(:degree_status).skipped?
      degree_country_uk = other_step(:degree_country).uk?

      callback_not_offered || overseas_country_skipped || degree_status_skipped || degree_country_uk
    end

    def title_attribute
      :fieldset
    end
  end
end
