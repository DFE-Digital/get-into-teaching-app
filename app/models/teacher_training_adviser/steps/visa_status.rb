module TeacherTrainingAdviser::Steps
  class VisaStatus < ::GITWizard::Step
    attribute :visa_status, :integer
    validates :visa_status,
              presence: { message: "Choose an option from the list" },
              inclusion: { in: :visa_status_ids }

    include FunnelTitle

    def visa_statuses
      @visa_statuses ||= PickListItemsApiPresenter.new.get_candidate_visa_status
    end

    def visa_status_ids
      visa_statuses.map { |option| option.id.to_i }
    end

    def skipped?
      other_step(:citizenship).uk_citizen?
    end

    def reviewable_answers
      {
        "visa_status" => visa_status ? I18n.t("helpers.answer.teacher_training_adviser_steps.visa_status.visa_status.#{visa_status}", **Value.data) : nil,
      }
    end
  end
end

