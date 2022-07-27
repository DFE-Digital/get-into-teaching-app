module Events
  module Steps
    class PersonalDetails < ::GITWizard::Step
      include ::GITWizard::IssueVerificationCode

      attribute :email
      attribute :first_name
      attribute :last_name
      attribute :is_walk_in, :boolean

      validates :email, presence: true, email_format: true
      validates :first_name, presence: true, length: { maximum: 256 }
      validates :last_name, presence: true, length: { maximum: 256 }

      def is_walk_in?
        is_walk_in.present?
      end

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
