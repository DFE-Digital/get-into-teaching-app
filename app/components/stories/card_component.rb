module Stories
  class CardComponent < ViewComponent::Base
    attr_accessor :name, :snippet, :link, :image, :video

    def initialize(card:)
      @card = card

      @name    = card["name"]
      @snippet = card["snippet"]
      @link    = card["link"]
      @image   = card["image"]
      @video   = card["video"]
    end

    def media_link
      @video ? video_link : image_link
    end

  private

    def image_link
      link_to(link, class: "story-card__thumb") do
        image_tag(image, data: { "object-fit" => "cover" })
      end
    end

    def video_link
      link_to(video, class: "story-card__thumb", data: { action: "click->video#play", target: "video.link" }) do
        safe_join([tag.div(helpers.fas_icon("play"), class: "story-card__thumb--play-icon"), image_tag(image)])
      end
    end
  end
end
