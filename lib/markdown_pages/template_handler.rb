module MarkdownPages
  class TemplateHandler
    attr_reader :template, :source, :options

    def self.call(template, source = nil)
      new(template, source).call
    end

    def initialize(template, source = nil, **options)
      @template = template
      @source = source.to_s

      @options = options.reverse_merge(
        no_intra_emphasis:            true,
        fenced_code_blocks:           true,
        space_after_headers:          true,
        smartypants:                  true,
        disable_indented_code_blocks: true,
        prettify:                     true,
        tables:                       true,
        with_toc_data:                true,
        autolink:                     true,
      )
    end

    def call
      # inspect objects to Ruby strings which can be eval'd
      %(@frontmatter = #{front_matter.inspect}; #{render.inspect}.html_safe)
    end

  private

    def renderer
      Redcarpet::Render::HTML.new(filter_html: false, hard_wrap: true)
    end

    def render
      Redcarpet::Markdown.new(renderer, options).render(markdown)
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
