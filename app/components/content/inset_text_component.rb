module Content
  class InsetTextComponent < ViewComponent::Base
    attr_reader :header, :title, :text, :color

    include ContentHelper

    def initialize(text:, title: nil, header: nil, color: "yellow")
      super

      @text = substitute_values(text)
      @title = substitute_values(title)
      @header = substitute_values(header.present? && title.present? ? "#{header}:" : header)
      @color = color
    end

    def classes
      %w[inset-text].tap do |c|
        c << color
      end
    end
  end
end
