module TemplateHandlers
  class ERB < ActionView::Template::Handlers::ERB
    CONTENT_DIR = Rails.root.join("app/views/content").freeze

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
        resources = Dir.glob(content_pattern).map do |file|
          {
            path: path(file),
            front_matter: front_matter(file),
          }
        end

        { resources: resources }
      end

      def path(file)
        pathname = Pathname.new(file).sub_ext("")
        "/#{pathname.relative_path_from(CONTENT_DIR)}"
      end

      def content_pattern
        "#{CONTENT_DIR}/**/*.{md,markdown}"
      end

      def front_matter(file)
        parse(file).front_matter
      end

      def parse(file)
        FrontMatterParser::Parser.parse_file(file)
      end
    end
  end
end
