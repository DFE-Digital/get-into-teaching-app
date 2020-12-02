class WaysToTrainController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    @page = Pages::Page.find(ways_to_train_template)
    render template: @page.template, layout: "layouts/accordion"
  end

private

  def ways_to_train_template
    "/ways-to-train"
  end
end
