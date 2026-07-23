# multi parameter date fields aren't yet support by ActiveModel so we
# need to include the support for them from ActiveRecord
require "active_record/attribute_assignment"

module ProviderEvents
  module Steps
    class EventTimes < ::GITWizard::Step
      include ::ActiveRecord::AttributeAssignment
      include FunnelTitle

      attribute :start_time, :time
      attribute :end_time, :time

      validates :start_time, presence: true
      validates :end_time, presence: true
      validates :end_time, comparison: { greater_than: :start_time }, if: -> { start_time.present? }
      validate :event_date_and_start_time_cannot_be_in_the_past

      def event_date_and_start_time_cannot_be_in_the_past
        if event_date.present? && start_time.present?
          dt = Time.zone.local(event_date.year, event_date.month, event_date.day, start_time.hour, start_time.min, start_time.sec)
          errors.add(:start_time, "Can't be in the past") if dt < Time.zone.now
        end
      end

      def event_date
        other_step(:event_date).event_date
      end
    end
  end
end
