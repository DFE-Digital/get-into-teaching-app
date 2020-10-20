require "acronyms"

module TemplateHandlers
  class Markdown
    attr_reader :template, :source, :options

    DEFAULTS = {}.freeze
    GLOBAL_FRONT_MATTER = Rails.root.join("config/frontmatter.yml").freeze

    class << self
      def call(template, source = nil)
        new(template, source).call
      end

      def global_front_matter
        @global_front_matter ||= begin
          if GLOBAL_FRONT_MATTER.exist?
            YAML.load_file GLOBAL_FRONT_MATTER
          else
            {}
          end
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
      %(@front_matter = #{front_matter.inspect}; #{render.inspect}.html_safe)
    end

  private

    def render_markdown
      Kramdown::Document.new(markdown).to_html
    end

    def autolink_html(content)
      Rinku.auto_link content
    end

    def add_abbreviations(content)
      Acronyms.new(content, front_matter["acronyms"]).render
    end

    def render
      add_abbreviations autolink_html render_markdown
    end

    def markdown
      parsed.content
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
