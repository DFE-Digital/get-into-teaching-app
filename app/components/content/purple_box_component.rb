module Content
  class PurpleBoxComponent < ViewComponent::Base
    attr_reader :heading, :text, :cta, :image

    def initialize(heading:, text:, cta:, image:)
      super

      @heading = heading
      @text = text
      @cta = cta
      @image = image
    end

    def cta_link
      link_to(cta[:text], cta[:path], class: :button)
    end
  end
end
