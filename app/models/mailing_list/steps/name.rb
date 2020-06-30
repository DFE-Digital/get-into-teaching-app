module MailingList
  module Steps
    class Name < ::Wizard::Step
      CURRENT_STATUSES = [
        "Student",
        "Exploring my career options",
        "Looking to change career",
        "Not studying and no plans to",
      ].freeze

      attribute :first_name
      attribute :last_name
      attribute :email_address
      attribute :current_status

      validates :email_address, presence: true, email_format: true
      validates :first_name, presence: true
      validates :last_name, presence: true
      validates :current_status,
                presence: true,
                inclusion: { in: CURRENT_STATUSES, allow_nil: true }

      before_validation if: :email_address do
        self.email_address = email_address.to_s.strip
      end

      before_validation if: :first_name do
        self.first_name = first_name.to_s.strip
      end

      before_validation if: :last_name do
        self.last_name = last_name.to_s.strip
      end

      class << self
        def current_statuses
          CURRENT_STATUSES
        end
      end
    end
  end
end
