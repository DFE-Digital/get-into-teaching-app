module Pages
  class Data
    def find_page(path)
      Frontmatter.find(path)
    end

    def featured_page
      Page.featured
    end
  end
end
