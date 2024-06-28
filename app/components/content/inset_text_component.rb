module Content
  class InsetTextComponent < ViewComponent::Base
    attr_reader :title, :text, :color

    def initialize(text:, title: nil, color: "yellow")
      super

      @text = text
      @title = title
      @color = color
    end

    def classes
      %w[inset-text].tap do |c|
        c << color
      end
    end
  end
end
