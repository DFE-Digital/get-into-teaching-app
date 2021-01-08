class GuidanceController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template

  def show
    @page = Pages::Page.find guidance_template
    render template: @page.template, layout: "layouts/content"
  end

private

  def guidance_template
    "/guidance/#{filtered_page_template}"
  end
end
