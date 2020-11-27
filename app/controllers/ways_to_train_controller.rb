class WaysToTrainController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    render template: steps_to_become_a_teacher_template, layout: "layouts/accordion"
  end

private

  def steps_to_become_a_teacher_template
    "content/steps-to-become-a-teacher"
  end
end
