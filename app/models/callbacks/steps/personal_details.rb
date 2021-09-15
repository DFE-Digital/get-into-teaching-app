module Callbacks
  module Steps
    class PersonalDetails < ::DFEWizard::Step
      include ::Wizard::IssueVerificationCode

      attribute :email
      attribute :first_name
      attribute :last_name

      validates :email, presence: true, email_format: true
      validates :first_name, presence: true, length: { maximum: 256 }
      validates :last_name, presence: true, length: { maximum: 256 }

      before_validation if: :email do
        self.email = email.to_s.strip
      end

      before_validation if: :first_name do
        self.first_name = first_name.to_s.strip
      end

      before_validation if: :last_name do
        self.last_name = last_name.to_s.strip
      end
    end
  end
end
