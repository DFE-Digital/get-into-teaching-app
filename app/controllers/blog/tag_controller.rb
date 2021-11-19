class Blog::TagController < ApplicationController
  include PaginatablePosts

  layout "layouts/blog/index"

  POSTS_PER_PAGE = 10

  def show
    breadcrumb "Blog", blog_index_path

    @front_matter = {
      "title" => "Blog posts about #{params[:id].tr('-', ' ')}",
    }

    @tag = params[:id]
    @posts = paginate_posts(::Pages::Blog.posts(@tag))
  end
end
