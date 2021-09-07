module Header
  class HeroComponent < ViewComponent::Base
    attr_accessor :title, :subtitle, :image, :show_mailing_list

    def initialize(front_matter)
      return if front_matter.blank?

      front_matter.with_indifferent_access.tap do |fm|
        @title           = fm["heading"] || fm["title"]
        @subtitle        = fm["subtitle"]
        @subtitle_link   = fm["subtitle_link"]
        @subtitle_button = fm["subtitle_button"]
        @image           = fm["image"]
        @mobile_image    = fm["mobileimage"]
      end
    end

    def classes
      %w[hero]
    end

    def render?
      image.present?
    end

    def picture
      tag.img(src: image_path, data: { "lazy-disable": true }, alt: "Photograph of teaching taking place in a classroom")
    end

    def show_subtitle?
      @subtitle.present?
    end

    def show_subtitle_button?
      [@subtitle_link, @subtitle_button].all?(&:present?)
    end

  private

    def image_path
      helpers.hero_image_path(image)
    end

    def mobile_image_path
      helpers.hero_image_path(mobile_image)
    end
  end
end
