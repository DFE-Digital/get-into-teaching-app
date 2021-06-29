class BlogController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]

  layout "layouts/blog/index"

  def index
    @front_matter = { title: "Blog" }

    @posts = Pages::Frontmatter
      .select_by_path("/blog")
      .select { |_path, fm| fm[:date] <= Time.zone.today.iso8601 }
      .sort_by { |_path, fm| fm[:date] }
  end

  def show
    breadcrumb "Blog", blog_index_path

    @page = Pages::Page.find(request.path)

    render template: @page.template, layout: "layouts/blog/post"
  end
end
