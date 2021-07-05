module Pages
  class Blog
    class << self
      delegate :posts, :popular_tags, to: :instance

    private

      def instance
        new
      end
    end

    def initialize(pages = Pages::Frontmatter.select_by_path("/blog"))
      @posts = pages
        .select { |_path, fm| fm[:date] <= Time.zone.today.iso8601 }
        .sort_by { |_path, fm| fm[:date] }
        .reverse
        .to_h
    end

    def posts(tag = nil)
      return @posts unless tag

      @posts.select { |_path, fm| tag.in?(fm[:tags]) }
    end

    # return the most-frequently used tags, ordered by frequency then
    # alphabetically if there are ties
    def popular_tags(limit = 5)
      posts
        .flat_map { |_path, fm| fm[:tags] }
        .compact
        .tally
        .sort_by { |tag, count| [-count, tag] }
        .map { |tag, _count| tag }
        .first(limit)
    end
  end
end
