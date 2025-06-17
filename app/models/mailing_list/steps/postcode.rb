module MailingList
  module Steps
    class Postcode < ::GITWizard::Step
      attribute :address_postcode

      validates :address_postcode, postcode: true

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.upcase.presence
      end

      include FunnelTitle

      def optional?
        true
      end
    end
  end
end
