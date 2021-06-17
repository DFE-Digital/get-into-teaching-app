class SearchesController < ApplicationController
  before_action :set_page_title

  def show
    @search = Search.new(search_params)

    respond_to do |format|
      format.json { render json: autocomplete_results(@search.results) }
      format.html
    end
  end

private

  def set_page_title
    @page_title = "Search Get Into Teaching"
  end

  def search_params
    params.fetch(:search, {}).permit(:search)
  end

  def autocomplete_results(results)
    (results || []).map do |page|
      path = page[:path]
      frontmatter = page[:frontmatter]

      {
        link: path,
        title: frontmatter[:title],
        html: render_result(path, frontmatter),
      }
    end
  end

  def render_result(*inline_result)
    render_to_string \
      partial: "inline_result",
      object: inline_result,
      formats: [:html]
  end
end
