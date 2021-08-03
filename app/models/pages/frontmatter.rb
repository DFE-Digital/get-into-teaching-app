module Pages
  class BadFrontmatterError < RuntimeError; end

  class Frontmatter
    attr_reader :content_dirs

    class << self
      def find(template, content_dirs = nil)
        instance(content_dirs).find template
      end

      def list(content_dirs = nil)
        instance(content_dirs).list
      end

      def select(selector, content_dirs = nil)
        instance(content_dirs).select(selector)
      end

      def select_by_path(path, content_dirs = nil)
        instance(content_dirs).select_by_path(path)
      end

      def default_content_dirs
        app_view_paths.map do |view_path|
          "#{view_path}/content"
        end
      end

    private

      def instance(content_dirs)
        if perform_caching
          @new ||= new(content_dirs).preload
        else
          new(content_dirs)
        end
      end

      def perform_caching
        Rails.application.config.action_controller.perform_caching
      end

      def app_view_paths
        ApplicationController.view_paths.select do |view_path|
          view_path.path.to_s.starts_with? Rails.root.to_s
        end
      end
    end

    delegate :default_content_dirs, to: :class

    def initialize(content_dirs = nil)
      content_dirs = Array.wrap(content_dirs).presence || default_content_dirs

      @content_dirs = content_dirs.map(&Pathname.public_method(:new))
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
      content_dirs.reverse.each do |content_dir|
        Dir.glob(content_pattern(content_dir)) do |found|
          next if File.basename(found).starts_with? "_"

          add path(content_dir, found), found
        end
      end

      self
    end

    def preloaded?
      !@frontmatter.nil?
    end

    def select(selector)
      list.select do |_path, frontmatter|
        case selector
        when Symbol, String
          frontmatter.key? selector.to_sym
        when Hash
          selector.all? { |k, v| frontmatter.key?(k) && frontmatter[k] == v }
        else
          raise UnknownSelectorType, selector
        end
      end
    end

    def select_by_path(path)
      list.select { |k, _v| k.start_with?(path) }
    end

    class NotMarkdownTemplate < RuntimeError
      def initialize(template)
        super "Cannot find Markdown Page #{template}.md"
      end
    end

    class UnknownSelectorType < RuntimeError
      def initialize(selector)
        super "Unknown selector type: #{selector.class}: #{selector.inspect}"
      end
    end

    class BlankContentDir < RuntimeError
      def initialize
        super "No content dirs specified"
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

    def add(template_path, file)
      frontmatter[template_path] = extract_frontmatter(file)
    end

    def path(content_dir, file)
      Pathname.new(file).sub_ext("").relative_path_from(content_dir).to_s.prepend("/")
    end

    def extract_frontmatter(file)
      FrontMatterParser::Parser.parse_file(file).front_matter.symbolize_keys
    rescue Psych::SyntaxError => e
      fail(BadFrontmatterError, "error in #{file}: #{e}")
    end

    def file_from_template(template)
      unprefixed = template.delete_prefix("/")

      content_dirs.each do |content_dir|
        if content_dir.join("#{unprefixed}.md").exist?
          return content_dir.join("#{unprefixed}.md")
        elsif content_dir.join("#{unprefixed}.markdown").exist?
          return content_dir.join("#{unprefixed}.markdown")
        end
      end

      raise NotMarkdownTemplate, template
    end

    def content_pattern(content_dir)
      # Guard against a full filesystem scan
      raise BlankContentDir if content_dir.blank?

      "#{content_dir}/**/*.{md,markdown}"
    end
  end
end
