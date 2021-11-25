# frozen_string_literal: true

class SingleQuestionSurveyComponent < ViewComponent::Base
  attr_reader :question, :hint, :answers

  def initialize(question:, answers:, hint: "")
    super

    @question = question
    @hint = hint
    @answers = answers
  end
end
