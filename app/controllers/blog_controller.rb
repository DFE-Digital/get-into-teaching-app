class BlogController < ApplicationController
  def index
    @front_matter = {}

    render(layout: "blog/index")
  end

  def show
    @front_matter = { title: "Top tips for last-minute applications" }

    render("content/blog/top-tips-for-last-minute-applications", layout: "blog/post", front_matter: { title: "omg" })
  end
end
