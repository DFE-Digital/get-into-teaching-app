module Content
  class ImageComponent < ViewComponent::Base
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def render?
      path.present?
    end

    def call
      helpers.image_pack_tag(path)
    end
  end
end
