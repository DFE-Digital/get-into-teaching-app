module SitemapHelper
  def navigation_resources
    Pages::Navigation.root_pages
  end
end
