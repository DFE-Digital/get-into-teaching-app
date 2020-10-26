module Stories
  class StoryComponent < ViewComponent::Base
    attr_accessor :title,
                  :image,
                  :video,
                  :teacher,
                  :position,
                  :more_stories,
                  :more_information,
                  :backlink,
                  :backlink_text,
                  :more_information_text,
                  :more_information_link,
                  :front_matter

    def initialize(front_matter)
      front_matter.tap do |fm|
        @title         = fm["title"]
        @image         = fm["image"]
        @backlink      = fm["backlink"]
        @backlink_text = fm["backlink_text"]
        @more_stories  = fm["more_stories"]

        @teacher  = fm.dig("story", "teacher")
        @position = fm.dig("story", "position")
        @video    = fm.dig("story", "video")

        @more_information_text = fm.dig("more_information", "text")
        @more_information_link = fm.dig("more_information", "link")
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
  end
end
