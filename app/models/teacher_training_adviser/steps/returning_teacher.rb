module TeacherTrainingAdviser::Steps
  class ReturningTeacher < GITWizard::Step
    OPTIONS = { returning_to_teaching: 222_750_001, interested_in_teaching: 222_750_000 }.freeze

    attribute :type_id, :integer

    validates :type_id, pick_list_items: { method: :get_candidate_types }

    def returning_to_teaching
      type_id == OPTIONS[:returning_to_teaching]
    end

    def reviewable_answers
      {
        "returning_to_teaching" => returning_to_teaching ? "Yes" : "No",
      }
    end
  end
end
