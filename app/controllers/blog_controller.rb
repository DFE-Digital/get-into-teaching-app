class BlogController < ApplicationController
  include PaginatablePosts

  caches_page :show

  layout "layouts/blog/index"

  def index
    @front_matter = { "title" => "Get Into Teaching Blog" }

    breadcrumb "Blog", blog_index_path

    @posts = paginate_posts(::Pages::Blog.posts)
  end

  def show
    @post = ::Pages::Blog.find(request.path)

    begin
      @post.validate!
    rescue ::Pages::ContentError => e
      raise e unless helpers.display_content_errors?

      add_content_error(e)
    end

    breadcrumb "Blog", blog_index_path
    breadcrumb @post.title, request.path

    render template: @post.template, layout: "layouts/blog/post"
  end
end
