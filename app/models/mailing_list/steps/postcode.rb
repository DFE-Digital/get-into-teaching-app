module MailingList
  module Steps
    class Postcode < ::DFEWizard::Step
      attribute :address_postcode
      attribute :send_event_emails, :boolean

      validates :send_event_emails, inclusion: { in: [true, false] }
      validates :address_postcode, postcode: true
      validates :address_postcode, presence: true, if: -> { send_event_emails }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.upcase.presence
      end

      def export
        super.tap do |hash|
          hash["address_postcode"] = postcode_in_crm unless send_event_emails
        end
      end

    private

      def postcode_in_crm
        @store.preexisting(:address_postcode)
      end
    end
  end
end
