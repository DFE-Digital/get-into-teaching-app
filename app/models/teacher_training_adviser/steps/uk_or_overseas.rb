module TeacherTrainingAdviser::Steps
  class UkOrOverseas < GITWizard::Step
    attribute :uk_or_overseas, :string

    OPTIONS = { uk: "UK", overseas: "Overseas" }.freeze

    validates :uk_or_overseas, inclusion: { in: OPTIONS.values }

    include FunnelTitle

    def uk?
      uk_or_overseas == OPTIONS[:uk]
    end

    def overseas?
      uk_or_overseas == OPTIONS[:overseas]
    end

    def uk_or_overseas_key
      if uk?
        :uk
      elsif overseas?
        :overseas
      end
    end

    def reviewable_answers
      {
        "uk_or_overseas" => uk_or_overseas ? I18n.t("helpers.answer.teacher_training_adviser_steps.uk_or_overseas.uk_or_overseas.#{uk_or_overseas_key}", **Value.data) : nil,
      }
    end
  end
end
