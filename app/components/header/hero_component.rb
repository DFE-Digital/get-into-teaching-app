module Header
  class HeroComponent < ViewComponent::Base
    attr_accessor :title, :subtitle, :image, :show_mailing_list

    def initialize(front_matter)
      return if front_matter.blank?

      super

      front_matter.with_indifferent_access.tap do |fm|
        @title           = fm["heading"] || fm["title"]
        @subtitle        = fm["subtitle"]
        @subtitle_link   = fm["subtitle_link"]
        @subtitle_button = fm["subtitle_button"]
        @image           = fm["image"]
      end
    end

    def classes
      %w[hero]
    end

    def render?
      image.present?
    end

    def picture
      helpers.image_pack_tag(@image, alt: helpers.image_alt(@image), **picture_data_args)
    end

    def picture_data_args
      { data: { "lazy-disable": true } }
    end

    def show_subtitle?
      @subtitle.present?
    end

    def show_subtitle_button?
      [@subtitle_link, @subtitle_button].all?(&:present?)
    end
  end
end
