class PagesController < ApplicationController
  def home
    render template: "pages/home"
  end

  def events
    render template: "pages/events"
  end

  def show
    render template: "content/#{params[:page]}", layout: "layouts/content"
  end
end
