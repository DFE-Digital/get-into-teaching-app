class PagesController < ApplicationController
  def home
    render template: "pages/home"
  end

  def show
    render template: "pages/#{params[:page]}"
  end
end
