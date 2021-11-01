class Blog::TagController < ApplicationController
  layout "layouts/blog/index"

  # TODO: fix this hideousness
  skip_after_action :process_images, :process_links
  caches_page :index, :show
  after_action :process_images, :process_links

  def show
    breadcrumb "Blog", blog_index_path

    @front_matter = {
      "title" => "Blog posts about #{params[:id].tr('-', ' ')}",
    }

    @tag = params[:id]

    @posts = ::Pages::Blog.posts(@tag)
  end
end
