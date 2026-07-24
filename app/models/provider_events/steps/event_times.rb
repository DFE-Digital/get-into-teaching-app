module ProviderEvents
  module Steps
    class EventTimes < ::GITWizard::Step
      include FunnelTitle

      # NB: multi parameter date fields aren't yet supported by ActiveModel so
      # we are doing things a bit manually here
      attribute :start_time, :time
      attribute "start_time(4i)", :integer
      attribute "start_time(5i)", :integer
      attribute "start_time(6i)", :integer

      attribute :end_time, :time
      attribute "end_time(4i)", :integer
      attribute "end_time(5i)", :integer
      attribute "end_time(6i)", :integer

      before_validation :parse_times

      validates :start_time, presence: true
      validates :end_time, presence: true
      validates :end_time, comparison: { greater_than: :start_time }, if: -> { start_time.present? }
      validate :event_date_and_start_time_cannot_be_in_the_past

      def event_date_and_start_time_cannot_be_in_the_past
        if event_date.present? && start_time.present? && (start_time < timezone.now)
          errors.add(:start_time, "Can't be in the past")
        end
      end

    private

      def event_date
        other_step(:event_date).event_date
      end

      def parse_times
        start_hour = send("start_time(4i)")
        start_minute = send("start_time(5i)")
        end_hour = send("end_time(4i)")
        end_minute = send("end_time(5i)")

        self.start_time = cast_to_time(start_hour, start_minute)
        self.end_time = cast_to_time(end_hour, end_minute)
      end

      def cast_to_time(hour, minute)
        return if hour.nil? || minute.nil?

        begin
          if event_date.present?
            # NB: Time.zone.local casts to the wrong timezone
            timezone.local(event_date.year, event_date.month, event_date.day, hour, minute)
          else
            timezone.local(2000, 1, 1, hour, minute)
          end
        rescue ArgumentError
          # catch invalid times, e.g. 25:62
          nil
        end
      end

      def timezone
        # Ensure all dates and times are centred on a UK timezone
        @timezone ||= ActiveSupport::TimeZone["Europe/London"]
      end
    end
  end
end
