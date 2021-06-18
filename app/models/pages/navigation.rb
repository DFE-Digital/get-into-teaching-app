module Pages
  class Navigation
    attr_reader :nodes

    class << self
      delegate :all_pages, :root_pages, to: :instance

    private

      def instance
        new
      end
    end

    def initialize(pages = Pages::Frontmatter.list)
      @nodes = pages
        .select { |_p, fm| fm.key?(:navigation) }
        .map { |p, fm| Node.new(p, fm) }
    end

    def all_pages
      nodes.sort_by(&:rank)
    end

    def root_pages
      nodes.select(&:root?).sort_by(&:rank)
    end

    class Node
      attr_reader :path, :title, :rank

      def initialize(path, front_matter)
        @path = front_matter[:navigation_path] || path

        front_matter.tap do |fm|
          @title = fm[:navigation_title] || fm[:title] || (Rails.logger.warn("page #{path} has no title") && nil)
          @rank  = fm.fetch(:navigation, nil)
          @menu  = fm.fetch(:menu, false)
        end
      end

      def root?
        path !~ %r{\A/.*/(\S+)\z}
      end

      def menu?
        @menu
      end
    end
  end
end
