module ProviderEvents
  module Steps
    class OnlinePostcode < ::GITWizard::Step
      include FunnelTitle

      attribute :online_postcode
      validates :online_postcode, presence: true, postcode: true, length: { maximum: 10 }

      before_validation :normalise_postcode

      def skipped?
        other_step(:event_type).in_person?
      end

    private

      def normalise_postcode
        self.online_postcode = online_postcode.strip.upcase.presence if online_postcode.present?
      end
    end
  end
end
