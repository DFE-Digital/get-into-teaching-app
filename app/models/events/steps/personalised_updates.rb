module Events
  module Steps
    class PersonalisedUpdates < ::Wizard::Step
      attribute :address_postcode

      validates :address_postcode, postcode: { allow_blank: true }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.presence
      end
    end
  end
end
