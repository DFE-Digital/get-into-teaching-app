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
      @link_text || "Read #{story_name}'s story"
    end

    def border
      false
    end

    def image
      @image ||= featured_metadata["image"] || story.image
    end

    def header
      @header ||= featured_metadata["title"] || "#{story_name}'s story"
    end

    def snippet
      @snippet ||= story.frontmatter.title || raise(MissingTitleOnFeatured, story.path)
    end

    class NoFeaturedStory < RuntimeError; end

    class MissingTitleOnFeatured < RuntimeError
      def initialize(story_path)
        super "Featured story is missing a 'title' - #{story_path}"
      end
    end

  private

    def story
      @story ||= @page_data.featured_page || raise(NoFeaturedStory)
    end

    def story_name
      story.frontmatter.story["name"]
    end

    def featured_metadata
      case story.frontmatter.featured
      when Hash then story.frontmatter.featured
      else {}
      end
    end
  end
end
