class Blog::TagController < ApplicationController
  layout "layouts/blog/index"

  include StaticPageCache
  cache_actions :show

  def show
    breadcrumb "Blog", blog_index_path

    @front_matter = {
      "title" => "Blog posts about #{params[:id].tr('-', ' ')}",
    }

    @tag = params[:id]

    @posts = ::Pages::Blog.posts(@tag)
  end
end
