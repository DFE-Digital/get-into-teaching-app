module Pages
  class Frontmatter
    MARKDOWN_CONTENT_DIR = Rails.root.join("app/views/content").freeze
    attr_reader :content_dir

    class << self
      def find(template, content_dir = nil)
        instance(content_dir).find template
      end

      def list(content_dir = nil)
        instance(content_dir).list
      end

      def instance(content_dir)
        if perform_caching
          @new ||= new(content_dir).preload
        else
          new(content_dir)
        end
      end

      def perform_caching
        Rails.application.config.action_controller.perform_caching
      end
    end

    def initialize(content_dir = nil)
      @content_dir = content_dir ? Pathname.new(content_dir) : MARKDOWN_CONTENT_DIR
    end

    def find(template)
      preloaded? ? find_from_preloaded(template) : find_now(template)
    end
    alias_method :[], :find

    def list
      preload unless preloaded?

      frontmatter
    end
    alias_method :to_h, :find

    def preload
      Dir.glob(content_pattern, &method(:add))

      self
    end

    def preloaded?
      !@frontmatter.nil?
    end

    class NotMarkdownTemplate < RuntimeError
      def initialize(template)
        super "Cannot find Markdown Page #{template}.md"
      end
    end

  private

    def find_now(template)
      extract_frontmatter file_from_template(template)
    end

    def find_from_preloaded(template)
      if @frontmatter.key? template
        @frontmatter[template]
      else
        raise NotMarkdownTemplate, template
      end
    end

    def frontmatter
      @frontmatter ||= {}
    end

    def add(file)
      frontmatter[path(file)] = extract_frontmatter(file)
    end

    def path(file)
      Pathname.new(file).sub_ext("").relative_path_from(content_dir).to_s.prepend("/")
    end

    def extract_frontmatter(file)
      FrontMatterParser::Parser.parse_file(file).front_matter.symbolize_keys
    end

    def file_from_template(template)
      unprefixed = template.delete_prefix("/")

      if content_dir.join("#{unprefixed}.md").exist?
        content_dir.join("#{unprefixed}.md")
      elsif content_dir.join("#{unprefixed}.markdown").exist?
        content_dir.join("#{unprefixed}.markdown")
      else
        raise NotMarkdownTemplate, template
      end
    end

    def content_pattern
      "#{content_dir}/**/*.{md,markdown}"
    end
  end
end
