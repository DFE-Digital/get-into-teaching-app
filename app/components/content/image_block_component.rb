module Content
  class ImageBlockComponent < ViewComponent::Base
    attr_reader :title, :image

    def initialize(title:, image:)
      super

      @title = title
      @image = image
    end
  end
end
