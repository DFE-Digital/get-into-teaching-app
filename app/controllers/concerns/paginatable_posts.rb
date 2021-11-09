module PaginatablePosts
  extend ActiveSupport::Concern

  POSTS_PER_PAGE = 10

  def paginate_posts(posts)
    posts_as_array = posts.map { |path, frontmatter| { path: path, fm: frontmatter } }
    @posts = Kaminari
      .paginate_array(posts_as_array)
      .page(params[:page])
      .per(POSTS_PER_PAGE)
  end
end
