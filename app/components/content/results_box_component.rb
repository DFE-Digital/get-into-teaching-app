module Content
  class ResultsBoxComponent < ViewComponent::Base
    attr_reader :title, :heading, :fee, :course_length, :funding, :text, :cta

    include ContentHelper

    def initialize(title:, heading:, fee:, course_length:, funding:, text:, cta:)
      super

      @title = substitute_values(title)
      @heading = substitute_values(heading)
      @fee = substitute_values(fee)
      @course_length = substitute_values(course_length)
      @funding = substitute_values(funding)
      @text = substitute_values(text)
      @cta = cta
    end
  end
end
