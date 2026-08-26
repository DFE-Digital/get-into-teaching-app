module MailingList
  module Steps
    class Postcode < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :address_postcode

      validates :address_postcode, postcode: true

      normalizes :address_postcode, with: ->(field) { field.to_s.squish.upcase.presence }

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
