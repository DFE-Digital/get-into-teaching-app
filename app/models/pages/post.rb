module Pages
  class Post < Page
    def validate!
      invalid_tags = frontmatter.tags - tags_whitelist

      message = "These tags are not defined in tags.yml: #{invalid_tags.to_sentence}"
      raise ContentError.new(message, "#tags") if invalid_tags.any?
    end

  private

    def tags_whitelist
      @tags_whitelist ||= YAML.load_file(Rails.root.join("config/tags.yml"))
    end
  end
end
