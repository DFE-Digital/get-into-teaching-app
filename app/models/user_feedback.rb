# frozen_string_literal: true

class UserFeedback < ApplicationRecord
  scope :recent, -> { order(created_at: :desc) }
  scope :on_or_after, ->(date) { where("created_at >= ?", date.beginning_of_day) }
  scope :on_or_before, ->(date) { where("created_at <= ?", date.end_of_day) }

  before_validation :sanitize_input
  after_create :publish_metrics

  enum rating: {
    very_satisfied: 0,
    satisfied: 1,
    neither_satisfied_or_dissatisfied: 2,
    dissatisfied: 3,
    very_dissatisfied: 4,
  }

  validates :topic, presence: true
  validates :rating, presence: true, inclusion: { in: UserFeedback.ratings.keys }
  validates :explanation, presence: true

private

  def sanitize_input
    self.explanation = explanation&.strip.presence
  end

  def publish_metrics
    ActiveSupport::Notifications.instrument("app.tta_feedback", self)
  end
end
