class PagesController < ApplicationController
  def home
    render template: "pages/home"
  end
  
  def event
    render template: "pages/events/event"
  end

  def events
    render template: "pages/events/events"
  end

  def eventregistration
    render template: "pages/events/registration/step1"
  end 

  def show
    render template: "content/#{params[:page]}", layout: "layouts/content"
  end
end
