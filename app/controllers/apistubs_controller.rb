class ApistubsController < ApplicationController
  def show
    render template: "apistubs/#{params[:stub]}"
  end
end
