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
    render template: "pages/events/registration/step1"
  end

  def eventregistration2
    render template: "pages/events/registration/step2"
  end

  def eventregistration3
    render template: "pages/events/registration/step3"
  end

  def eventregistration4
    render template: "pages/events/registration/step4"
  end

  def show
    render template: "content/#{params[:page]}", layout: "layouts/content"
  end
end
