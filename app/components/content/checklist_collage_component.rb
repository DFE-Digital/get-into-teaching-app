module Content
  class ChecklistCollageComponent < ViewComponent::Base
    attr_reader :checklist, :image_paths, :cta

    include ContentHelper

    def initialize(checklist:, image_paths:, cta: nil)
      super

      @checklist = checklist.map { |item| substitute_values(item) }
      @image_paths = image_paths
      @cta = cta
    end

    def images
      safe_join(
        image_paths.map do |path|
          image_pack_tag(path, **helpers.image_alt_attribs(path))
        end,
      )
    end

    def image_classes
      ["images", "images-#{image_paths.count}"]
    end
  end
end
