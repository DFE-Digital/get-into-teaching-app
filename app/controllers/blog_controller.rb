class BlogController < ApplicationController
  include PaginatablePosts

  layout "layouts/blog/index"

  def index
    @front_matter = { "title" => "Get Into Teaching Blog" }

    breadcrumb "Blog", blog_index_path

    @posts = paginate_posts(::Pages::Blog.posts)
  end

  def show
    @post = ::Pages::Blog.find(request.path)

    breadcrumb "Blog", blog_index_path
    breadcrumb @post.title, request.path

    render template: @post.template, layout: "layouts/blog/post"
  end

protected

  def static_page_actions
    %i[show]
  end
end
