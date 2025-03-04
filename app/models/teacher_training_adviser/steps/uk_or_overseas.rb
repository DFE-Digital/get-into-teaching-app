module TeacherTrainingAdviser::Steps
  class UkOrOverseas < GITWizard::Step
    attribute :uk_or_overseas, :string

    OPTIONS = { uk: "UK", overseas: "Overseas" }.freeze

    validates :uk_or_overseas, inclusion: { in: OPTIONS.values }

    def uk?
      uk_or_overseas == OPTIONS[:uk]
    end

    def reviewable_answers
      {
        "uk_or_overseas" => uk_or_overseas,
      }
    end

    def title
      "location"
    end
  end
end
