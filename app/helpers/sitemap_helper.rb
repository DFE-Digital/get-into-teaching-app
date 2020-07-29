module SitemapHelper
  def navigation_resources(sitemap)
    resources = sitemap[:resources].select do |resource|
      resource.dig(:front_matter, "navigation")
    end
    resources.sort_by { |resource| resource.dig(:front_matter, "navigation") }
  end
end
