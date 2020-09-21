class StoriesController < ApplicationController
  include StaticPages
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

  def show
    new_stories = ["becoming-a-mum-sparked-my-interest-in-teaching"]
    is_new_story = new_stories.any? { |story| params[:story].include?(story) }
    layout = is_new_story ? "layouts/stories" : "layouts/stories_old"

    render template: stories_template, layout: layout
  end

private

  def stories_template
    "content/life-as-a-teacher/my-story-into-teaching/" + filtered_page_template(:story)
  end
end
