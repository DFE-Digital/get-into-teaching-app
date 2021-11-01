module Events
  class MobileSignupInfo < ViewComponent::Base
    attr_reader :event

    def initialize(event)
      @event = event

      super
    end

    def date
      return if event.start_at.blank?

      event.start_at.to_date.to_formatted_s(:govuk)
    end

    def start_time
      format_time(event.start_at)
    end

    def end_time
      format_time(event.end_at)
    end

  private

    def format_time(datetime)
      return if datetime.blank?

      datetime.to_formatted_s(:time)
    end
  end
end
