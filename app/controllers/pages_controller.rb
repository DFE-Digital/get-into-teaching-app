class PagesController < ApplicationController
  def home
    render template: "pages/home"
  end

  def event
    render template: "pages/events/event"
  end

  def eventschool
    render template: "pages/events/eventschool"
  end

  def events
    render template: "pages/events/events"
  end

  def eventregistration
    render template: "pages/events/registration/step#{params[:step_number]}"
  end

  def mailingregistration
    render template: "pages/mailinglist/registration/step#{params[:step_number]}"
  end

  def show
    render template: "content/#{params[:page]}", layout: "layouts/content"
  end
end
