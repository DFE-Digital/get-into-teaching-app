class StepsToBecomeATeacherController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template

  def show
    @page = Pages::Page.find(steps_to_become_a_teacher_template)
    render template: @page.template, layout: "layouts/accordion"
  end

private

  def steps_to_become_a_teacher_template
    "/steps-to-become-a-teacher"
  end
end
