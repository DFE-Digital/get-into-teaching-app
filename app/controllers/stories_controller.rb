class StoriesController < ApplicationController
  include StaticPages
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    render template: stories_template, layout: "layouts/stories"
  end

private

  def stories_template
    "content/life-as-a-teacher/my-story-into-teaching/" + filtered_page_template(:story)
  end
end
