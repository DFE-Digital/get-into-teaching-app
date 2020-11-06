class StepsToBecomeATeacherController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    render template: "content/steps-to-become-a-teacher", layout: "layouts/steps_to_become_a_teacher"
  end
end
