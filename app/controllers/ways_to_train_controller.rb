class WaysToTrainController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    render template: ways_to_train_template, layout: "layouts/accordion"
  end

private

  def ways_to_train_template
    "content/ways-to-train"
  end
end
