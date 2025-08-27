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

      def skipped?
        # Don't show the postcode if you are not a UK Citizen AND your location is not in the UK.
        !other_step(:citizenship).uk_citizen? && !other_step(:location).inside_the_uk?
      end
    end
  end
end
