module SitemapHelper
  def navigation_resources
    Pages::Frontmatter
      .list
      .select { |_relative_path, fm| fm.key?(:navigation) }
      .sort_by { |_relative_path, fm| fm.fetch(:navigation) }
      .map { |relative_path, fm| { path: relative_path, front_matter: fm } }
  end
end
