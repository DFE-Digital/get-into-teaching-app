class Blog::TagController < ApplicationController
  layout "layouts/blog/index"

  def show
    breadcrumb "Blog", blog_index_path

    @front_matter = {
      "title" => "Blog posts about #{params[:id].tr('-', ' ')}",
    }

    @tag = params[:id]

    @posts = ::Pages::Blog.posts(@tag)
  end

protected

  def static_page_actions
    %i[show]
  end
end
