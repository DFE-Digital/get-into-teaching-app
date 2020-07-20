module MailingList
  module Steps
    class Postcode < ::Wizard::Step
      attribute :address_postcode
      validates :address_postcode, presence: true, postcode: true

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.presence
      end
    end
  end
end
