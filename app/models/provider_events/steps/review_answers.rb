module ProviderEvents
  module Steps
    class ReviewAnswers < ::GITWizard::Step
      include FunnelTitle

      EVENT_DETAILS = [Steps::Email,
                       Steps::EventName,
                       Steps::EventDescription,
                       Steps::OrganisationName,
                       Steps::EventWebsite,
                       Steps::TargetAudience,
                       Steps::EventDate,
                       Steps::EventTimes].freeze

      VENUE_DETAILS = [Steps::EventType,
                       Steps::OnlinePostcode,
                       Steps::InPersonLocation,
                       Steps::NewVenue].freeze

      REGISTRATION_DETAILS = [Steps::RegistrationDetails].freeze

      def event_details_answers_by_step
        filtered_answers_by_step(EVENT_DETAILS)
      end

      def venue_details_answers_by_step
        filtered_answers_by_step(VENUE_DETAILS)
      end

      def registration_details_answers_by_step
        filtered_answers_by_step(REGISTRATION_DETAILS)
      end

      def seen?
        false # ensure this step is always shown
      end

    private

      def filtered_answers_by_step(filter)
        answers_by_step.select { |k| filter.include?(k) }
      end

      def answers_by_step
        @answers_by_step ||= @wizard.reviewable_answers_by_step
      end
    end
  end
end
