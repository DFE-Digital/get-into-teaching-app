module ProviderEvents
  module Steps
    class OnlinePostcode < ::GITWizard::Step
      include FunnelTitle
      include NormalisePostcode

      attribute :online_postcode
      validates :online_postcode, presence: true, postcode: true, length: { maximum: 10 }

      before_validation -> { normalise_postcode :online_postcode }

      def skipped?
        other_step(:event_type).in_person?
      end

      def reviewable_answers
        super if other_step(:event_type).online?
      end
    end
  end
end
