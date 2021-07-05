class Blog::TagController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]

  layout "layouts/blog/index"

  def show
    breadcrumb "Blog", blog_index_path

    @front_matter = {
      title: "Blog posts about #{params[:id]}",
    }

    @tag = params[:id]

    @posts = Pages::Frontmatter
      .select_by_path("/blog")
      .select { |_path, fm| fm[:date] <= Time.zone.today.iso8601 }
      .select { |_path, fm| @tag.in?(fm[:tags]) }
      .sort_by { |_path, fm| fm[:date] }
      .reverse
  end
end
