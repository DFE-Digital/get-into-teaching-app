module Pages
  class Frontmatter
    MARKDOWN_CONTENT_DIR = Rails.root.join("app/views/content").freeze
    attr_reader :content_dir

    class << self
      def find(template, content_dir)
        new(content_dir).find template
      end
    end

    def initialize(content_dir = nil)
      @content_dir = content_dir || MARKDOWN_CONTENT_DIR
    end

    def find(template)
      extract_frontmatter file_from_template(template)
    end
    alias_method :[], :find

    class MissingTemplate < RuntimeError
      def initialize(tmpl)
        super "Cannot find Markdown Page #{tmpl}.md"
      end
    end

  private

    def extract_frontmatter(file)
      FrontMatterParser::Parser.parse_file(file).front_matter.symbolize_keys
    end

    def file_from_template(template)
      if content_dir.join("#{template}.md").exist?
        content_dir.join("#{template}.md")
      elsif content_dir.join("#{template}.markdown").exist?
        content_dir.join("#{template}.markdown")
      else
        raise MissingTemplate, template
      end
    end
  end
end
