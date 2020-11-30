module Content
  module Accordion
    class StoryComponent < ViewComponent::Base
      attr_reader :name, :heading, :image, :link, :text

      def initialize(name:, heading:, image:, link:, text:)
        @name    = name
        @heading = heading
        @image   = image
        @link    = link
        @text    = text
      end

      def button
        link_to(tag.span("Read #{name}'s story"), link, class: "call-to-action__contents__button")
      end
    end
  end
end
