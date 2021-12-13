module SubjectSpecific
  class HeaderComponent < ViewComponent::Base
    attr_accessor :title, :colour

    def initialize(title:, colour:, image:)
      super

      @title = title
      @colour = colour
      @image = image
    end

    def header_image
      image_pack_tag(@image) if @image
    end

    def classes
      [].tap do |c|
        c << colour
      end
    end
  end
end
