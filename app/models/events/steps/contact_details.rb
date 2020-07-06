module Events
  module Steps
    class ContactDetails < ::Wizard::Step
      attribute :phone_number
      validates :phone_number, phone_number: true, allow_blank: true

      before_validation if: :phone_number do
        self.phone_number = phone_number.to_s.strip
      end
    end
  end
end
