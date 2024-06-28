class FeedbackSearch
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Multi parameter date fields aren't yet support by ActiveModel so we
  # need to include the support for them from ActiveRecord.
  require "active_record/attribute_assignment"
  include ::ActiveRecord::AttributeAssignment

  attribute :created_on_or_after, :date, default: -> { Time.zone.now.beginning_of_month.utc }
  attribute :created_on_or_before, :date, default: -> { Time.zone.now.end_of_day.utc }

  validates :created_on_or_after, presence: true
  validates :created_on_or_before, presence: true
  validates :created_on_or_after, timeliness: {
    on_or_before: :created_on_or_before,
  }
  validates :created_on_or_before, timeliness: {
    on_or_before: -> { Time.zone.now.end_of_day.utc.to_date },
  }

  def range
    [created_on_or_after, created_on_or_before]
  end

  def results
    return [] if invalid?

    UserFeedback
      .on_or_after(created_on_or_after)
      .on_or_before(created_on_or_before)
      .recent
  end
end
