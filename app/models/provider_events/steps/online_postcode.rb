require "postcodes_io"

module ProviderEvents
  module Steps
    class OnlinePostcode < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :online_postcode
      attribute :online_district_or_region

      validates :online_postcode, presence: true, postcode: true, length: { maximum: 10 }
      normalizes :online_postcode, with: ->(field) { field.to_s.squish.upcase.presence }

      after_validation :lookup_district_or_region

      def skipped?
        other_step(:event_type).in_person?
      end

      def reviewable_answers
        if other_step(:event_type).online?
          if online_district_or_region.present?
            { "online_postcode" => "#{online_postcode.presence} (#{online_district_or_region})" }
          else
            { "online_postcode" => online_postcode.presence }
          end
        end
      end

    private

      def online_postcode_valid?
        errors[:online_postcode].blank?
      end

      def lookup_district_or_region
        self.online_district_or_region = if online_postcode_valid?
                                           PostcodesIO.new(online_postcode).district_or_region
                                         end
      end
    end
  end
end
