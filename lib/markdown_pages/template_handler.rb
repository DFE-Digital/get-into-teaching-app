module MarkdownPages
  class TemplateHandler
    attr_reader :template, :source, :options

    DEFAULTS = {}.freeze

    def self.call(template, source = nil)
      new(template, source).call
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

    def render
      Govspeak::Document.new(markdown).to_html
    end

    def markdown
      parsed.content
    end

    def front_matter
      parsed.front_matter
    end

    def parsed
      @parsed ||= parser.call(source)
    end

    def parser
      FrontMatterParser::Parser.new(:md)
    end
  end
end
