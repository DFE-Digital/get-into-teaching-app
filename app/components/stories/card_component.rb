module Stories
  class CardComponent < ::CardComponent
    attr_reader :name

    def initialize(card:)
      super(card: card)
      @name = card["name"]
    end

    def link_text
      "Read #{name}'s story"
    end
  end
end
