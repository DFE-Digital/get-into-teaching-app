class SearchesController < ApplicationController
  before_action :set_page_title, :noindex

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
    search_param = params.fetch(:search, {})

    # Covers the case when someone manually enters
    # /search?search or /search?search= into the address bar.
    return nil unless search_param.is_a?(ActionController::Parameters)

    search_param.permit(:search)
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
