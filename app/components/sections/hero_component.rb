module Sections
  class HeroComponent < ViewComponent::Base
    attr_accessor :title, :image, :mobile_image, :subtitle, :show_mailing_list

    attr_accessor :deep

    def initialize(front_matter)
      front_matter.tap do |fm|
        @title             = fm["title"]
        @subtitle          = fm["subtitle"]
        @image             = fm["image"]
        @mobile_image      = fm["mobile_image"] || false
        @show_mailing_list = fm["mailinglist"]
      end

      # only used in two places, move to template
      @deep = true
    end

    def render?
      image.present?
    end
  end
end
