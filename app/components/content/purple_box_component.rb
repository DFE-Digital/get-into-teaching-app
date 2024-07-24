module Content
  class PurpleBoxComponent < ViewComponent::Base
    attr_reader :heading, :text, :cta, :image

    include ContentHelper

    def initialize(heading:, text:, cta:, image:)
      super

      @heading = substitute_values(heading)
      @text = substitute_values(text)
      @cta = cta
      @image = image
    end

    def cta_link
      link_to(cta[:text], cta[:path], class: :button)
    end
  end
end
