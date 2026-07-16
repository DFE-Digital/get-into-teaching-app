module ProviderEvents
  module Steps
    class EventDateTimes < ::GITWizard::Step
      include FunnelTitle

      attribute :start_date_time, :datetime
      attribute :end_date_time, :datetime

      validates :start_date_time, presence: true
      validates :end_date_time, presence: true, comparison: { greater_than: :start_date_time }
    end
  end
end
