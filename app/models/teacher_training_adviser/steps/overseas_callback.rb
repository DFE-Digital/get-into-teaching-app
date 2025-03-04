module TeacherTrainingAdviser::Steps
  class OverseasCallback < GITWizard::Step
    extend CallbackBookingQuotas

    attribute :phone_call_scheduled_at, :datetime

    validates :phone_call_scheduled_at, presence: true

    def reviewable_answers
      {
        "callback_date" => phone_call_scheduled_at&.to_date,
        "callback_time" => phone_call_scheduled_at&.to_time,
      }
    end

    def skipped?
      callback_not_offered = !other_step(:overseas_time_zone).callback_offered
      overseas_country_skipped = other_step(:overseas_country).skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_skipped = have_a_degree_step.skipped?
      equivalent_degree = have_a_degree_step.degree_options == HaveADegree::DEGREE_OPTIONS[:equivalent]

      callback_not_offered || overseas_country_skipped || have_a_degree_skipped || !equivalent_degree
    end

    def title
      "callback time"
    end
  end
end
