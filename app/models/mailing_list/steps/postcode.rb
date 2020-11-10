module MailingList
  module Steps
    class Postcode < ::Wizard::Step
      attribute :address_postcode
      validates :address_postcode, postcode: true

      before_validation if: :address_postcode do
        self.address_postcode = UKPostcode.parse(address_postcode).to_s.presence
      end
    end
  end
end
