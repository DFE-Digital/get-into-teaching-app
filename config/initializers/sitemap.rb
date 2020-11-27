class Sitemap
  attr_reader :content_dir, :all_pages, :navbar

  def initialize(content_dir: Rails.root.join("app/views/content"))
    @content_dir = content_dir
    @all_pages = populate_all_pages
    @navbar = populate_navbar
  end

private

  def populate_all_pages
    Dir.glob("#{content_dir}/**/[^_]*.{md,markdown}")
      .each
      .with_object({}) do |full_path, all_pages|
        all_pages[relative_path(full_path)] = parse(full_path).front_matter
      end
  end

  def populate_navbar
    all_pages
      .select { |_relative_path, fm| fm.key?("navigation") }
      .sort_by { |_relative_path, fm| fm.fetch("navigation") }
      .map { |relative_path, fm| { path: relative_path, front_matter: fm } }
  end

  def parse(file)
    FrontMatterParser::Parser.parse_file(file)
  end

  def relative_path(full_path)
    path = Pathname.new(full_path).sub_ext("")
    "/" + path.relative_path_from(content_dir).to_path
  end
end

SITEMAP = Sitemap.new
