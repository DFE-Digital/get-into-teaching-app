class GuidanceController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    render template: guidance_template, layout: "layouts/guidance"
  end

private

  def guidance_template
    "content/guidance/#{filtered_page_template}"
  end
end
