module ProviderEvents
  module Steps
    class OnlinePostcode < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :online_postcode
      validates :online_postcode, presence: true, postcode: true, length: { maximum: 10 }
      normalizes :postcode, with: ->(field) { field.to_s.squish.upcase.presence }

      def skipped?
        other_step(:event_type).in_person?
      end

      def reviewable_answers
        super if other_step(:event_type).online?
      end
    end
  end
end
