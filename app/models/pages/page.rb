module Pages
  class Page
    class PageNotFoundError < RuntimeError; end

    TEMPLATES_FOLDER = "content".freeze

    attr_reader :path, :frontmatter

    delegate :title, :image, to: :frontmatter

    class << self
      def find(path)
        new path, Pages::Frontmatter.find(path)
      rescue Pages::Frontmatter::NotMarkdownTemplate => e
        raise PageNotFoundError, e.message
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

    def parent
      pathname = Pathname.new(path)

      loop do
        pathname = pathname.parent
        return nil if pathname.root?

        return self.class.find(pathname.to_s)
      rescue PageNotFoundError
        next
      end
    end

    def ancestors
      ancestors = []
      page = self

      loop do
        page = page.parent
        return ancestors if page.nil?

        ancestors << page
      end
    end

    class MultipleFeatured < RuntimeError
      def initialize(page_paths)
        super "There are multiple featured pages: #{page_paths.join(', ')}"
      end
    end
  end
end
