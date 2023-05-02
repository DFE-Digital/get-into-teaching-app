module TeacherTrainingAdviser
  class Feedback < ApplicationRecord
    scope :recent, -> { order(created_at: :desc) }
    scope :on_or_after, ->(date) { where("created_at >= ?", date.beginning_of_day) }
    scope :on_or_before, ->(date) { where("created_at <= ?", date.end_of_day) }

    before_validation :sanitize_input

    enum rating: {
      very_satisfied: 0,
      satisfied: 1,
      neither_satisfied_or_dissatisfied: 2,
      dissatisfied: 3,
      very_dissatisfied: 4,
    }

    validates :rating, presence: true, inclusion: { in: Feedback.ratings.keys }
    validates :successful_visit, inclusion: [true, false]
    validates :unsuccessful_visit_explanation, presence: true, if: -> { successful_visit == false }

  private

    def sanitize_input
      self.unsuccessful_visit_explanation = unsuccessful_visit_explanation&.strip.presence
      self.improvements = improvements&.strip.presence
    end
  end
end
