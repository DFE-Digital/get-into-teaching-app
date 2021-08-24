module Events
  class MobileSignupInfo < ViewComponent::Base
    attr_reader :event

    def initialize(event)
      @event = event
    end
  end
end
