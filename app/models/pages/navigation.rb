module Pages
  class Navigation
    def initialize(pages)
      @pages = pages
        .select { |_relative_path, fm| fm.key?(:navigation) }
        .sort_by { |_relative_path, fm| fm.fetch(:navigation) }
        .map { |relative_path, fm| node(pages, relative_path, fm) }
    end

    def to_a
      @pages
    end

  private

    def retrieve_children(pages, parent_path)
      pages
        .select { |_, fm| parent_path == fm.dig(:parent, :path) }
        .sort_by { |_, fm| fm.dig(:parent, :navigation) }
        .map { |relative_path, fm| { path: relative_path, front_matter: fm } }
    end

    def node(pages, relative_path, front_matter)
      {
        path: relative_path,
        front_matter: front_matter,
        children: retrieve_children(pages, relative_path),
      }
    end
  end
end
