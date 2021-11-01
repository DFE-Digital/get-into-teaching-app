class BlogController < ApplicationController
  layout "layouts/blog/index"

  # TODO: fix this hideousness
  skip_after_action :process_images, :process_links
  caches_page :index, :show
  after_action :process_images, :process_links

  def index
    @front_matter = { "title" => "Get Into Teaching Blog" }

    @posts = ::Pages::Blog.posts
  end

  def show
    breadcrumb "Blog", blog_index_path

    @post = ::Pages::Blog.find(request.path)

    render template: @post.template, layout: "layouts/blog/post"
  end
end
