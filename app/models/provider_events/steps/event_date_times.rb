module ProviderEvents
  module Steps
    class EventDateTimes < ::GITWizard::Step
      include FunnelTitle

      attribute :start_date_time, :datetime
      attribute :end_date_time, :datetime

      validates :start_date_time, presence: true, comparison: { greater_than: :present }
      validates :end_date_time, presence: true, comparison: { greater_than: :start_date_time, less_than: :start_date_at_midnight }

    private

      def present
        Time.zone.now
      end

      def start_date_at_midnight
        start_date_time.midnight + 1.day if start_date_time.present?
      end
    end
  end
end
