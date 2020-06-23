module Events
  module Steps
    class PersonalDetails < ::Wizard::Step
      attribute :first_name
      attribute :last_name
      attribute :email_address

      validates :first_name, presence: true
      validates :last_name, presence: true
      validates :email_address, presence: true
    end
  end
end
