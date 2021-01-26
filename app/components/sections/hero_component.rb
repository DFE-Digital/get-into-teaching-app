module Sections
  class HeroComponent < ViewComponent::Base
    attr_accessor :title, :image, :mobile_image, :show_mailing_list

    def initialize(front_matter)
      front_matter.with_indifferent_access.tap do |fm|
        @title             = fm["title"]
        @subtitle          = fm["subtitle"]
        @subtitle_link     = fm["subtitle_link"]
        @image             = fm["image"]
        @mobile_image      = fm["mobileimage"]
        @show_mailing_list = fm["mailinglist"]
      end
    end

    def classes
      %w[hero]
    end

    def render?
      image.present?
    end

    def responsive_image
      image_sizes = [%(#{image_path} 800w)]
      image_sizes << %(#{mobile_image_path} 600w) if mobile_image.present?

      image_tag(image_path, class: "hero__img", srcset: image_sizes.join(", "), alt: "Student in a classroom")
    end

    def subtitle
      if @subtitle_link.present?
        link_to(@subtitle, @subtitle_link)
      else
        @subtitle
      end
    end

    def show_subtitle?
      @subtitle.present?
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
