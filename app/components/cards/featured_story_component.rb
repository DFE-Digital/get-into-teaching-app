module Cards
  class FeaturedStoryComponent < CardComponent
    def initialize(card:, page_data:)
      super(card: card)
      @page_data = page_data
    end

    def link
      story.path
    end

    def link_text
      "Read more"
    end

    def border
      false
    end

    def image
      @image ||= story.frontmatter.featured[:image] || story.image
    end

    def header
      story.frontmatter.featured[:title] || story.title
    end

    def snippet
      story.frontmatter.featured[:snippet] || raise(MissingSnippet, story.path)
    end

    class NoFeaturedStory < RuntimeError; end

    class MissingSnippet < RuntimeError
      def initialize(story_path)
        super "Featured story is missing the 'snippet' - #{story_path}"
      end
    end

  private

    def story
      @story ||= @page_data.featured_page || raise(NoFeaturedStory)
    end
  end
end
