module TemplateHandlers
  class Markdown
    include ActionView::Helpers::OutputSafetyHelper

    attr_reader :template, :source, :options

    DEFAULTS = {}.freeze
    GLOBAL_FRONT_MATTER = Rails.root.join("config/frontmatter.yml").freeze
    COMPONENT_PLACEHOLDER_REGEX = /\$([A-z0-9-]+)\$/
    COMPONENT_TYPES = %w[quote inset_text].freeze

    class << self
      def call(template, source = nil)
        new(template, source).call
      end

      def global_front_matter
        @global_front_matter ||= if GLOBAL_FRONT_MATTER.exist?
                                   YAML.load_file(GLOBAL_FRONT_MATTER) || {}
                                 else
                                   {}
                                 end
      end
    end

    def initialize(template, source = nil, **options)
      @template = template
      @source = source.to_s

      @options = DEFAULTS.merge(options)
    end

    def call
      # inspect objects to Ruby strings which can be eval'd
      return %(#{render.inspect}.html_safe) if front_matter == TemplateHandlers::Markdown.global_front_matter

      %(@front_matter = #{front_matter.inspect}; #{render.inspect}.html_safe)
    end

  private

    def render_markdown
      Kramdown::Document.new(markdown, { toc_levels: 1..2 }).to_html
    end

    def autolink_html(content)
      Rinku.auto_link content
    end

    def render
      autolink_html render_markdown
    end

    # rubocop:disable Style/PerlBackrefs
    def markdown
      # use $1 rather than a block argument here because gsub assigns the
      # entire placeholder to the arg (including dollar symbols) but we only
      # want what's inside the capture group
      parsed.content.gsub(COMPONENT_PLACEHOLDER_REGEX) do
        safe_join([cta_component($1), content_component($1), image($1)].compact).strip
      end
    end
    # rubocop:enable Style/PerlBackrefs

    def cta_component(placeholder)
      component = Content::CallToActionComponentInjector.new(
        front_matter.dig("calls_to_action", placeholder),
      ).component

      return unless component

      ApplicationController.render(component, layout: false)
    end

    def content_component(placeholder)
      component_type = COMPONENT_TYPES.find { |type| front_matter.dig(type, placeholder) }

      component = Content::ComponentInjector.new(
        component_type,
        front_matter.dig(component_type, placeholder),
      ).component

      return unless component

      ApplicationController.render(component, layout: false)
    end

    def image(placeholder)
      image_args = front_matter.dig("images", placeholder)

      return unless image_args

      component = Content::ImageComponent.new(path: image_args["path"])

      ApplicationController.render(component, layout: false)
    end

    def front_matter
      @front_matter ||= self.class.global_front_matter.deep_merge(parsed.front_matter)
    end

    def parsed
      @parsed ||= parser.call(source)
    end

    def parser
      FrontMatterParser::Parser.new(:md)
    end
  end
end
