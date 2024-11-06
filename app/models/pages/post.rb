module Pages
  class Post < Page
    def validate!
      invalid_tags = frontmatter.tags

      message = "Do not use tags in your post: #{invalid_tags.to_sentence}"
      raise ContentError.new(message, "#tags") if invalid_tags.any?
    end
  end
end
