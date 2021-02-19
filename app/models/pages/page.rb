module Pages
  class Page
    TEMPLATES_FOLDER = "content".freeze

    attr_reader :path, :frontmatter

    delegate :title, :image, to: :frontmatter

    class << self
      def find(path)
        new path, Pages::Frontmatter.find(path)
      rescue Pages::Frontmatter::NotMarkdownTemplate
        new path, {}
      end

      def featured
        pages = Pages::Frontmatter.select(:featured_story_card)
        return nil? if pages.empty?
        raise MultipleFeatured, pages.keys if pages.many?

        new(*pages.first)
      end
    end

    def initialize(path, frontmatter)
      @path = path
      @frontmatter = OpenStruct.new(frontmatter)
    end

    def template
      TEMPLATES_FOLDER + path
    end

    def data
      @data ||= Pages::Data.new
    end

    class MultipleFeatured < RuntimeError
      def initialize(page_paths)
        super "There are multiple featured pages: #{page_paths.join(', ')}"
      end
    end
  end
end
