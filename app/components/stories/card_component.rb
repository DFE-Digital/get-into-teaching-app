module Stories
  class CardComponent < ::CardComponent
    attr_reader :name

    def initialize(card:)
      super(card: card)
      @name = card["name"]
      @image_description = "A photograph of #{image_description_name}"
    end

    def link_text
      "Read #{name}'s story"
    end

  private

    def image_description_name
      name || "a teacher"
    end
  end
end
