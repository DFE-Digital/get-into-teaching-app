class StoriesController < ApplicationController
  include StaticPages
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def landing
    render template: landing_template, layout: "layouts/stories/landing"
  end

  def index
    render template: index_template, layout: "layouts/stories/list"
  end

  def show
    render template: stories_template, layout: "layouts/stories/story"
  end

private

  def landing_template
    "content/my-story-into-teaching"
  end

  def stories_template
    "content/my-story-into-teaching/" + filtered_page_template(:story)
  end

  def index_template
    ["content/my-story-into-teaching", filtered_page_template(:story), "index"].join("/")
  end
end
