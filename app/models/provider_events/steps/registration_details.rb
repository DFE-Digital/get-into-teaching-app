module ProviderEvents
  module Steps
    class RegistrationDetails < ::GITWizard::Step
      include FunnelTitle
      REGISTRATION_OPTIONS = [WEBSITE = "website".freeze, EMAIL = "email".freeze].freeze

      attribute :registration_option
      attribute :registration_email
      attribute :registration_website

      validates :registration_option, presence: true, inclusion: REGISTRATION_OPTIONS

      validates :registration_email, presence: true, email_format: true, length: { maximum: 100 }, if: -> { email_registration? } # NB: the CRM imposes a limit of 100 chars on this field
      validates :registration_website, presence: true, length: { maximum: 300 }, url: { no_local: true }, if: -> { website_registration? }

      def website_registration?
        registration_option == WEBSITE
      end

      def email_registration?
        registration_option == EMAIL
      end

      def reviewable_answers
        { "registration_details": if website_registration?
                                    registration_website
                                  elsif email_registration?
                                    registration_email
                                  end }
      end
    end
  end
end
