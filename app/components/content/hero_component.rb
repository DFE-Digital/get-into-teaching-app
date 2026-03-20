module Content


  class HeroComponent < ViewComponent::Base
    include ContentHelper
    include FieldTest::Helpers


    attr_accessor :title, :subtitle, :image, :show_mailing_list, :paragraph, :title_bg_color, :hero_bg_color, :hero_blend_content, :hero_content_width

    def initialize(front_matter)
      return if front_matter.blank?
      @front_matter = front_matter

      super
    end

    def before_render
      helpers.rebrand?.tap do |rebrand|
        set_value(:@title, @front_matter, ["heading", "title"], rebrand: rebrand)
        set_value(:@subtitle, @front_matter, "subtitle", rebrand: rebrand)
        set_value(:@subtitle_link, @front_matter, "subtitle_link", rebrand: rebrand)
        set_value(:@subtitle_button, @front_matter, "subtitle_button", rebrand: rebrand)
        set_value(:@image, @front_matter, "image", rebrand: rebrand)
        set_value(:@paragraph, @front_matter, "title_paragraph", rebrand: rebrand)
        set_value(:@title_bg_color, @front_matter, "title_bg_color", default: "yellow", rebrand: rebrand)
        set_value(:@hero_bg_color, @front_matter, "hero_bg_color", default: "grey", rebrand: rebrand)
        set_value(:@hero_blend_content, @front_matter, "hero_blend_content", default: false, rebrand: rebrand)
        set_value(:@hero_content_width, @front_matter, "hero_content_width", default: "even", rebrand: rebrand)
      end
    end

    def set_value(name, front_matter, fm_keys, default: nil, rebrand: false)
      return unless front_matter.present?

      if rebrand && front_matter["rebrand"].present? && set_value(name, front_matter["rebrand"], fm_keys)
        return true
      end

      active_key = [fm_keys].flatten.find{|key| front_matter[key].present? }

      return false unless active_key.present? || default.present?

      if active_key.present?
        instance_variable_set(name, substitute_values(front_matter[active_key]))
      elsif default
        instance_variable_set(name, default)
      end

      true
    end


    #
    # def initialize_with_front_matter(front_matter, defaults: {})
    #   return if front_matter.blank?
    #   front_matter.with_indifferent_access.tap do |fm|
    #     @title = substitute_values(fm["heading"] || fm["title"]) if fm["heading"] || fm["title"]
    #     @subtitle = substitute_values(fm["subtitle"]) if fm["subtitle"]
    #     @subtitle_link = fm["subtitle_link"] if fm["subtitle_link"]
    #     @subtitle_button = substitute_values(fm["subtitle_button"]) if fm["subtitle_button"]
    #     @image = fm["image"] if fm["image"]
    #     @paragraph = substitute_values(fm["title_paragraph"]) if fm["title_paragraph"]
    #     @title_bg_color = fm["title_bg_color"] if fm["title_bg_color"]
    #     @hero_bg_color = fm["hero_bg_color"] if fm["hero_bg_color"]
    #     @hero_blend_content = fm["hero_blend_content"] if fm["hero_blend_content"]
    #     @hero_content_width = fm["hero_content_width"] if fm["hero_content_width"]
    #   end
    #
    # def reinitialize_with_front_matter(front_matter, defaults: {})
    #   return if front_matter.blank?
    #   front_matter.with_indifferent_access.tap do |fm|
    #     @title = substitute_values(fm["heading"] || fm["title"]) if fm["heading"] || fm["title"]
    #     @subtitle = substitute_values(fm["subtitle"]) if fm["subtitle"]
    #     @subtitle_link = fm["subtitle_link"] if fm["subtitle_link"]
    #     @subtitle_button = substitute_values(fm["subtitle_button"]) if fm["subtitle_button"]
    #     @image = fm["image"] if fm["image"]
    #     @paragraph = substitute_values(fm["title_paragraph"]) if fm["title_paragraph"]
    #     @title_bg_color = fm["title_bg_color"] if fm["title_bg_color"]
    #     @hero_bg_color = fm["hero_bg_color"] if fm["hero_bg_color"]
    #     @hero_blend_content = fm["hero_blend_content"] if fm["hero_blend_content"]
    #     @hero_content_width = fm["hero_content_width"] if fm["hero_content_width"]
    #   end



    def classes
      ["hero", hero_bg_color].tap do |c|
        c << "blend-content" if hero_blend_content
        c << "content-#{hero_content_width}"
        c << "rebrand-2026" if helpers.rebrand?
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
