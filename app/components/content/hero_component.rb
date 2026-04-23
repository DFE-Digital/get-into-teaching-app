module Content
  class HeroComponent < ViewComponent::Base
    include ContentHelper

    attr_accessor :title, :subtitle, :image, :show_mailing_list, :paragraph, :title_bg_color, :hero_bg_color, :hero_blend_content, :hero_content_width

    def initialize(front_matter)
      return if front_matter.blank?

      @front_matter = front_matter
      super
    end

    def before_render
      set_value(:@title, @front_matter, %w[heading title])
      set_value(:@subtitle, @front_matter, "subtitle")
      set_value(:@subtitle_link, @front_matter, "subtitle_link")
      set_value(:@subtitle_button, @front_matter, "subtitle_button")
      set_value(:@image, @front_matter, "image")
      set_value(:@paragraph, @front_matter, "title_paragraph")
      set_value(:@title_bg_color, @front_matter, "title_bg_color", default: "gitlilac")
      set_value(:@hero_bg_color, @front_matter, "hero_bg_color", default: "grey")
      set_value(:@hero_blend_content, @front_matter, "hero_blend_content", default: false)
      set_value(:@hero_content_width, @front_matter, "hero_content_width", default: "even")
    end

    def set_value(name, front_matter, fm_keys, default: nil, rebrand: true)
      return if front_matter.blank?

      if rebrand && front_matter["rebrand"].present? && set_value(name, front_matter["rebrand"], fm_keys)
        return true
      end

      active_key = [fm_keys].flatten.find { |key| front_matter.key?(key) }

      return false unless active_key.present? || default.present?

      if active_key.present?
        instance_variable_set(name, substitute_values(front_matter[active_key]))
      elsif default
        instance_variable_set(name, default)
      end

      true
    end

    def classes
      token_list({
        "hero" => true,
        hero_bg_color => true,
        "blend-content" => hero_blend_content,
        "content-#{hero_content_width}" => true,
        "rebrand" => true,
      })
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
