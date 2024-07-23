module Content
  class InsetTextComponent < ViewComponent::Base
    attr_reader :header, :title, :text, :color

    def initialize(text:, title: nil, header: nil, color: "yellow")
      super

      @text = text
      @title = title
      @header = header.present? && title.present? ? "#{header}:" : header
      @color = color
    end

    def classes
      %w[inset-text].tap do |c|
        c << color
      end
    end
  end
end
