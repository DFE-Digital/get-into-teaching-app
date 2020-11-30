module TemplateHandlers
  class ERB < ActionView::Template::Handlers::ERB
    def call(template, source = nil)
      # inspect objects to Ruby strings which can be eval'd
      %(@sitemap = #{self.class.sitemap.inspect}; #{super}.html_safe)
    end

    class << self
      attr_writer :sitemap

      def sitemap
        @sitemap ||= build_sitemap
      end

      def build_sitemap
        {
          markdown_content: mapped_markdown_content,
        }
      end

    private

      def mapped_markdown_content
        Pages::Frontmatter.list.map(&method(:map_markdown_page))
      end

      def map_markdown_page(path, front_matter)
        {
          path: path,
          front_matter: front_matter,
        }
      end
    end
  end
end
