module ProviderEvents
  module Steps
    class NewVenue < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :venue_name
      attribute :address_line_1
      attribute :address_line_2
      attribute :address_line_3
      attribute :address_city
      attribute :address_postcode

      validates :venue_name, presence: true
      validates :address_postcode, presence: true, postcode: true, length: { maximum: 10 }

      normalizes :venue_name, :address_line_1, :address_line_2, :address_line_3, :address_city, with: ->(field) { field.to_s.squish.presence }
      normalizes :address_postcode, with: ->(field) { field.to_s.squish.upcase.presence }

      def skipped?
        other_step(:in_person_location).skipped? || other_step(:in_person_location).existing?
      end

      def reviewable_answers
        if other_step(:in_person_location).new?
          { "venue" => address.presence }
        end
      end

    private

      def address
        [venue_name, address_line_1, address_line_2, address_line_3, address_city, address_postcode].compact.join(", ")
      end
    end
  end
end
