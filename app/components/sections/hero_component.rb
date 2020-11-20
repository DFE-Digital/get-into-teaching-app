module Sections
  class HeroComponent < ViewComponent::Base
    attr_accessor :title, :image, :mobile_image, :subtitle, :show_mailing_list, :deep

    def initialize(front_matter, deep: false)
      front_matter.with_indifferent_access.tap do |fm|
        @title             = fm["title"]
        @subtitle          = fm["subtitle"]
        @image             = fm["image"]
        @mobile_image      = fm["mobileimage"]
        @show_mailing_list = fm["mailinglist"]
        @deep              = fm["deepheader"]
      end

    end

    def classes
      %w[hero].tap do |c|
        c << "hero--deep" if deep?
      end
    end

    def render?
      image.present?
    end

    def responsive_image
      image_sizes = [%(#{image_path} 800w)]
      image_sizes << %(#{mobile_image_path} 600w) if mobile_image.present?

      image_tag(image_path, srcset: image_sizes.join(", "), alt: "Student in a classroom")
    end

  private

    def deep?
      @deep
    end

    def image_path
      helpers.hero_image_path(image)
    end

    def mobile_image_path
      helpers.hero_image_path(mobile_image)
    end
  end
end
