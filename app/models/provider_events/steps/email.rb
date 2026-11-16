module ProviderEvents
  module Steps
    class Email < ::GITWizard::Step
      MAX_CHARS = 100

      include FunnelTitle

      attribute :provider_contact_email
      validates :provider_contact_email, presence: true, email_format: true, length: { maximum: MAX_CHARS } # NB: the CRM imposes a limit of 100 chars on this field
    end
  end
end
