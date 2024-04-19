module Content
  class LandingHeroComponent < ViewComponent::Base
    attr_accessor :title, :subtitle, :image, :show_mailing_list, :paragraph, :title_bg_color, :hero_bg_color, :hero_blend_content, :hero_content_width

    def initialize(front_matter)
      return if front_matter.blank?

      super

      front_matter.with_indifferent_access.tap do |fm|
        @title              = fm["heading"] || fm["title"]
        @subtitle           = fm["subtitle"]
        @subtitle_link      = fm["subtitle_link"]
        @subtitle_button    = fm["subtitle_button"]
        @image              = fm["image"]
        @paragraph          = fm["title_paragraph"]
        @title_bg_color     = fm["title_bg_color"] || "blue"
        @hero_bg_color      = fm["hero_bg_color"] || "pink"
        @hero_blend_content = fm["hero_blend_content"] || false
        @hero_content_width = fm["hero_content_width"] || "even"
      end
    end

    def classes
      ["landing-hero", hero_bg_color].tap do |c|
        c << "blend-content" if hero_blend_content
        c << "content-#{hero_content_width}"
      end
    end

    def render?
      image.present?
    end

    def picture
      helpers.image_pack_tag(@image, **helpers.image_alt_attribs(@image), **picture_data_args)
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
