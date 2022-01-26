module Stories
  class StoryComponent < ViewComponent::Base
    attr_accessor :title,
                  :image,
                  :video,
                  :teacher,
                  :position,
                  :more_stories,
                  :more_information,
                  :explore,
                  :more_information_text,
                  :more_information_link,
                  :front_matter,
                  :page_data

    def initialize(front_matter, page_data = nil)
      super

      front_matter.tap do |fm|
        @title         = fm["title"]
        @image         = fm["image"]
        @more_stories  = fm["more_stories"]
        @explore       = fm["explore"]

        @teacher  = fm.dig("story", "teacher")
        @position = fm.dig("story", "position")
        @video    = fm.dig("story", "video")

        @more_information_text = fm.dig("more_information", "text")
        @more_information_link = fm.dig("more_information", "link")

        @page_data = page_data
      end
    end

    def show_more_information?
      more_information_text.present? && more_information_link.present?
    end

    def show_video?
      video.present?
    end

    def show_more_stories?
      more_stories.present?
    end

    def show_explore?
      explore.present?
    end
  end
end
