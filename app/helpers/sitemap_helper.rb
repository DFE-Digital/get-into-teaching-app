module SitemapHelper
  def navigation_resources(sitemap)
    navigation_content = sitemap[:markdown_content].select do |content|
      content.dig(:front_matter, "navigation")
    end
    navigation_content.sort_by { |resource| resource.dig(:front_matter, "navigation") }
  end
end
