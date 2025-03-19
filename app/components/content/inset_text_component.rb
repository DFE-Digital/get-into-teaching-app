module Content
  class InsetTextComponent < ViewComponent::Base
    attr_reader :header, :text, :color, :heading_tag

    include ContentHelper

    def initialize(text:, header: nil, color: "yellow", heading_tag: "h2")
      super

      @text = substitute_values(text)
      @header = substitute_values(header)
      @color = color
      @heading_tag = heading_tag
    end

    def classes
      %w[inset-text].tap do |c|
        c << color
      end
    end
  end
end
