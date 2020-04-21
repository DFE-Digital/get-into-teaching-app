class PagesController < ApplicationController
  def home
    render template: "pages/home"
  end

  def show
    render template: "content/#{params[:page]}"
  end
end
