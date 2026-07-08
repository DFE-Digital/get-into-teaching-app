module ProviderEvents
  module Steps
    class Email < ::GITWizard::Step
      include FunnelTitle

      attribute :email
      validates :email, presence: true, email_format: true, length: { maximum: 254 }
    end
  end
end
