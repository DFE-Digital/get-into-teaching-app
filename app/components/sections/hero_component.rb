module Sections
  class HeroComponent < ViewComponent::Base
    attr_accessor :title, :image, :mobile_image, :subtitle, :show_mailing_list

    attr_accessor :deep

    def initialize(front_matter, deep: false)
      front_matter.tap do |fm|
        @title             = fm["title"]
        @subtitle          = fm["subtitle"]
        @image             = fm["image"]
        @mobile_image      = fm["mobile_image"] || false
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

private

    def deep?
      @deep
    end
  end
end
