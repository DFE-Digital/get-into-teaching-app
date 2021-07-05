module Pages
  class Blog
    class << self
      delegate :posts, :popular_tags, :similar_posts, to: :instance

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

      @posts.select { |_path, fm| tag.in?(fm[:tags].map(&:parameterize)) }
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

    def similar_posts(post, limit = 3)
      tags = post.frontmatter.tags

      posts
        .reject { |path, _fm| path == post.path }
        .sort_by { |_path, fm| -(tags & fm[:tags]).size }
        .first(limit)
        .to_h
    end
  end
end
