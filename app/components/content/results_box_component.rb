module Content
  class ResultsBoxComponent < ViewComponent::Base
    attr_reader :title, :heading, :fee, :course_length, :funding, :text, :border_color, :show_title

    include ContentHelper

    def initialize(heading:, fee:, course_length:, funding:, text:, border_color: :grey, show_title: false, title: nil)
      super

      if show_title && title.nil?
        raise ArgumentError, "Title must be provided when show_title is true"
      end

      @title = show_title ? substitute_values(title) : nil
      @heading = substitute_values(heading)
      @fee = substitute_values(fee)
      @course_length = substitute_values(course_length)
      @funding = substitute_values(funding)
      @text = substitute_values(text)
      @border_color = border_color
      @show_title = show_title
    end

    def border_class
      @border_color == :yellow ? "results-box--yellow" : "results-box--grey"
    end
  end
end
