module Content
  class InsetTextComponent < ViewComponent::Base
    attr_reader :title, :text

    def initialize(text:, title: nil)
      super

      @text = text
      @title = title
    end
  end
end
