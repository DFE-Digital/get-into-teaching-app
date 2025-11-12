module TeacherTrainingAdviser::Steps
  class Location < GITWizard::Step
    INSIDE_THE_UK = 222_750_000
    OUTSIDE_THE_UK = 222_750_001

    attribute :location, :integer
    validates :location, inclusion: { in: :locations_ids }

    include FunnelTitle

    def locations
      @locations ||= PickListItemsApiPresenter.new.get_candidate_location
    end

    def locations_ids
      locations.map { |option| option.id.to_i }
    end

    def uk?
      location == INSIDE_THE_UK
    end

    def overseas?
      location == OUTSIDE_THE_UK
    end

    def reviewable_answers
      {
        "location" => location ? I18n.t("helpers.answer.teacher_training_adviser_steps.location.location.#{location}", **Value.data) : nil,
      }
    end
  end
end
