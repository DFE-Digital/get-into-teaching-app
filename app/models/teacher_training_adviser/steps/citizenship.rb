module TeacherTrainingAdviser::Steps
  class Citizenship < ::GITWizard::Step
    UK_CITIZEN = 222_750_000

    attribute :citizenship, :integer
    validates :citizenship,
              presence: { message: "Choose an option from the list" },
              inclusion: { in: :citizenship_ids }

    include FunnelTitle

    def citizenships
      @citizenships ||= PickListItemsApiPresenter.new.get_candidate_citizenship
    end

    def citizenship_ids
      citizenships.map { |option| option.id.to_i }
    end

    def uk_citizen?
      citizenship == UK_CITIZEN
    end

    def reviewable_answers
      {
        "citizenship" => citizenship ? I18n.t("helpers.answer.teacher_training_adviser_steps.citizenship.citizenship.#{citizenship}", **Value.data) : nil,
      }
    end
  end
end
