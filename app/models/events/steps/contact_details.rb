module Events
  module Steps
    class ContactDetails < ::Wizard::Step
      include ActiveModel::Validations::Callbacks
      PHONE_NUMBER_FORMAT = %r{\A[0-9 ]+\z}.freeze

      attribute :phone_number

      validates :phone_number,
                format: { with: PHONE_NUMBER_FORMAT, message: :invalid_format },
                length: { minimum: 6, message: :invalid_format },
                allow_blank: true

      before_validation if: :phone_number do
        self.phone_number = phone_number.to_s.strip
      end
    end
  end
end
