class StoriesController < ApplicationController
    def show

        render template: "content/life-as-a-teacher/my-story-into-teaching/#{params[:story]}", layout: "layouts/stories"
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