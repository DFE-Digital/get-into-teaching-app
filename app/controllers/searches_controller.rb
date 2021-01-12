class SearchesController < ApplicationController
  def show
    @search = Search.new(params[:q])

    respond_to do |format|
      format.json { render json: @search.results }
      format.html
    end
  end
end
