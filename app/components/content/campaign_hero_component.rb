module Content
  class CampaignHeroComponent < ViewComponent::Base
    attr_accessor :title, :subtitle, :image

    def initialize(front_matter)
      super

      front_matter.with_indifferent_access.tap do |fm|
        @title = fm[:title]
        @subtitle = fm[:subtitle]
        @image = fm[:image]
      end
    end

    def picture
      helpers.image_pack_tag(@image, alt: helpers.image_alt(@image), **picture_data_args)
    end

    def picture_data_args
      { data: { "lazy-disable": true } }
    end
  end
end
