module ProviderEvents
  module Steps
    class Email < ::GITWizard::Step
      include FunnelTitle

      attribute :email
      validates :email, presence: true, email_format: true, length: { maximum: 100 } # NB: the CRm imposes a limit of 100 chars on this field
    end
  end
end
