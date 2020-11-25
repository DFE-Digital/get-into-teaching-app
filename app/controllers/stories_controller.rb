class StoriesController < ApplicationController
  include StaticPages
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template

  def landing
    @page = Pages::Page.find(landing_template)
    render template: @page.template, layout: "layouts/stories/landing"
  end

  def index
    @page = Pages::Page.find(index_template)
    render template: @page.template, layout: "layouts/stories/list"
  end

  def show
    @page = Pages::Page.find(stories_template)
    render template: @page.template, layout: "layouts/stories/story"
  end

private

  def landing_template
    "/my-story-into-teaching"
  end

  def stories_template
    "/my-story-into-teaching/" + filtered_page_template(:story)
  end

  def index_template
    ["/my-story-into-teaching", filtered_page_template(:story), "index"].join("/")
  end
end
