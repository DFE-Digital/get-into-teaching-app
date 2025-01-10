module Content
  class ResultsBoxComponent < ViewComponent::Base
    attr_reader :title, :heading, :fee, :course_length, :funding, :text, :link_text, :link_target, :border_color

    include ContentHelper

    def initialize(heading:, fee:, course_length:, funding:, text:, link_text:, link_target:, title: nil, border_color: :grey)
      super

      @title = substitute_values(title)
      @heading = substitute_values(heading)
      @fee = fee
      @course_length = substitute_values(course_length)
      @funding = substitute_values(funding)
      @text = substitute_values(text)
      @link_text = link_text
      @link_target = link_target
      @border_color = border_color
    end
  end
end
