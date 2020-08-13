class StoriesController < ApplicationController
  def show
    new_stories = ["becoming-a-mum-sparked-my-interest-in-teaching"]
    is_new_story = new_stories.any? { |story| params[:story].include?(story) }
    layout = is_new_story ? "layouts/stories" : "layouts/stories_old"

    render template: "content/life-as-a-teacher/my-story-into-teaching/#{params[:story]}", layout: layout
  rescue ActionView::MissingTemplate
    respond_to do |format|
      format.html do
        render \
          template: "errors/not_found",
          status: :not_found
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end
end
