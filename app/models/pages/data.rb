module Pages
  class Data
    def find_page(path)
      Frontmatter.find(path)
    end
  end
end
