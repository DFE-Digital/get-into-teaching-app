module CallsToAction
  class StoryComponent < ViewComponent::Base
    attr_reader :name, :heading, :image, :link, :text

    def initialize(name:, heading:, image:, link:, text:)
      super

      @name    = name
      @heading = heading
      @image   = image
      @link    = link
      @text    = text
    end
  end
end
