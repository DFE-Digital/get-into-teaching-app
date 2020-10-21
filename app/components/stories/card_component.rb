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
  end
end
