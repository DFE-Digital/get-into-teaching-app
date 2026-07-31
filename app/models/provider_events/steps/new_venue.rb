module ProviderEvents
  module Steps
    class NewVenue < ::GITWizard::Step
      include FunnelTitle
      include NormalisePostcode

      attribute :venue_name
      attribute :address_line_1
      attribute :address_line_2
      attribute :address_line_3
      attribute :address_city
      attribute :address_postcode

      validates :venue_name, presence: true
      validates :address_postcode, presence: true, postcode: true, length: { maximum: 10 }

      before_validation -> { normalise_postcode :address_postcode }

      def skipped?
        other_step(:in_person_location).skipped? || other_step(:in_person_location).existing?
      end
    end
  end
end
