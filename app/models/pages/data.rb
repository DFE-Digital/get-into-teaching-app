module Pages
  class Data
    def find_page(path)
      Frontmatter.find(path)
    end

    def latest_event_for_category(category)
      Events::Category.new(category).latest
    end
  end
end
