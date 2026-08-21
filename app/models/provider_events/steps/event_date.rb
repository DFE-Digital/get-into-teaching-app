module ProviderEvents
  module Steps
    class EventDate < ::GITWizard::Step
      include FunnelTitle

      attribute :event_date, :date

      validates :event_date, presence: true, comparison: { greater_than_or_equal_to: :today }

    private

      def today
        Time.zone.today
      end
    end
  end
end
