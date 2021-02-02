class SearchesController < ApplicationController
  before_action :set_page_title

  def show
    @search = Search.new(search_params)

    respond_to do |format|
      format.json { render json: @search.results }
      format.html
    end
  end

private

  def set_page_title
    @page_title = "Search Get into Teaching"
  end

  def search_params
    params.fetch(:search, {}).permit(:search)
  end
end
