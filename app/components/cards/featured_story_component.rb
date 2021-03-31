module Cards
  class FeaturedStoryComponent < CardComponent
    def initialize(card:, page_data:)
      super(card: card)
      @page_data = page_data
      @image_description = "A photograph of a teacher"
    end

    def link
      featured_story.path
    end

    def link_text
      @link_text ||= "Read #{story_candidates_name}'s story"
    end

    def border
      false
    end

    def image
      @image ||= featured_metadata["image"] || featured_story.image
    end

    def header
      @header ||= featured_metadata["title"] || "#{story_candidates_name}'s story"
    end

    def snippet
      @snippet ||=
        featured_story.frontmatter.title ||
        raise(MissingTitleOnFeatured, featured_story.path)
    end

    class NoFeaturedStory < RuntimeError; end

    class MissingTitleOnFeatured < RuntimeError
      def initialize(story_path)
        super "Featured story is missing a 'title' - #{story_path}"
      end
    end

  private

    def featured_story
      @featured_story ||= @page_data.featured_page || raise(NoFeaturedStory)
    end

    def story_candidates_name
      featured_story.frontmatter.story["teacher"].to_s.strip.split(%r{\s}).first
    end

    def featured_metadata
      case featured_story.frontmatter.featured_story_card
      when Hash then featured_story.frontmatter.featured_story_card
      else {}
      end
    end
  end
end
