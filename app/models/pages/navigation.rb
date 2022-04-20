module Pages
  class Navigation
    attr_reader :nodes

    class << self
      delegate :all_pages, :root_pages, :find, to: :instance

    private

      def instance
        new
      end
    end

    def initialize(pages = Pages::Frontmatter.list)
      @nodes = pages
        .select { |_p, fm| fm.key?(:navigation) }
        .map { |p, fm| Node.new(self, p, fm) }
    end

    def all_pages
      nodes.sort_by(&:rank)
    end

    def root_pages
      nodes.select(&:root?).sort_by(&:rank)
    end

    def find(path)
      all_pages.find { |p| p.path == path }
    end

    class Node
      attr_reader :navigation, :path, :title, :rank

      def initialize(navigation, path, front_matter)
        @navigation = navigation
        @path = front_matter[:navigation_path] || path

        front_matter.tap do |fm|
          @title = extract_title(fm) || (Rails.logger.warn("page #{path} has no title") && nil)
          @rank  = fm.fetch(:navigation, nil)
          @menu  = fm.fetch(:menu, false)
        end
      end

      def root?
        path !~ %r{\A/.*/(\S+)\z}
      end

      def children
        navigation.all_pages.select { |page| page.path.start_with?(path) && page.path != path }
      end

      def menu?
        @menu
      end

    private

      def extract_title(front_matter)
        front_matter.values_at(:navigation_title, :heading, :title).find(&:presence)
      end
    end
  end
end
