class Blog::TagController < ApplicationController
  include StaticPageCache
  around_action :cache_static_page, only: %i[show]

  layout "layouts/blog/index"

  def show
    breadcrumb "Blog", blog_index_path

    @front_matter = {
      "title" => "Blog posts about #{params[:id].tr('-', ' ')}",
    }

    @tag = params[:id]

    @posts = Pages::Blog.posts(@tag)
  end
end
