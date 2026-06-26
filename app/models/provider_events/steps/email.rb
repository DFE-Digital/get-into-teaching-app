module ProviderEvents
  module Steps
    class Email < ::GITWizard::Step
      include FunnelTitle

      attribute :email
      validates :email, presence: true, email_format: true
    end
  end
end
