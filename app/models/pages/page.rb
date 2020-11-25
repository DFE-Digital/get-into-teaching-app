module Pages
  class Page
    TEMPLATES_FOLDER = "content".freeze

    attr_reader :path, :frontmatter

    delegate :title, :image, :backlink, :backlink_text, to: :frontmatter

    class << self
      def find(path)
        new path, Pages::Frontmatter.find(path)
      rescue Pages::Frontmatter::NotMarkdownTemplate
        new path, {}
      end
    end

    def initialize(path, frontmatter)
      @path = path
      @frontmatter = OpenStruct.new(frontmatter)
    end

    def template
      TEMPLATES_FOLDER + path
    end
  end
end
