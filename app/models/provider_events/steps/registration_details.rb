module ProviderEvents
  module Steps
    class RegistrationDetails < ::GITWizard::Step
      include FunnelTitle
      REGISTRATION_OPTIONS = [WEBSITE = "website".freeze, EMAIL = "email".freeze].freeze

      attribute :registration_option
      attribute :registration_email
      attribute :registration_website

      validates :registration_option, presence: true, inclusion: REGISTRATION_OPTIONS

      validates :registration_email, presence: true, email_format: true, length: { maximum: 100 }, if: -> { email? } # NB: the CRM imposes a limit of 100 chars on this field
      validates :registration_website, presence: true, length: { maximum: 300 }, url: { no_local: true }, if: -> { website? }

      delegate :website?, :email?, to: :registration_option_inquiry

      def reviewable_answers
        { "registration_details": if website?
                                    registration_website
                                  elsif email?
                                    registration_email
                                  end }
      end

    private

      def registration_option_inquiry = registration_option.to_s.inquiry
    end
  end
end
