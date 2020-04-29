module MarkdownPages
  class TemplateHandler
    attr_reader :options

    def self.call(template, source = nil)
      new.call(template, source)
    end

    def initialize(options = {})
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

    def call(_template, source = nil)
      # inspect is so we return Ruby code instead of a string
      render(source).inspect
    end

    def renderer
      Redcarpet::Render::HTML.new(filter_html: false, hard_wrap: true)
    end

    def render(source)
      Redcarpet::Markdown.new(renderer, options).render(source.to_s)
    end
  end
end
