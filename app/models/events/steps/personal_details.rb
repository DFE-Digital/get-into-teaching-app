module Events
  module Steps
    class PersonalDetails < ::Wizard::Step
      attribute :email_address
      attribute :first_name
      attribute :last_name

      validates :email_address, presence: true, email_format: true
      validates :first_name, presence: true
      validates :last_name, presence: true

      before_validation if: :email_address do
        self.email_address = email_address.to_s.strip
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
