module Pages
  class BadFrontmatterError < RuntimeError; end

  class Frontmatter
    # Files whose basename contains this marker (e.g. `scholarships+v1.md`) are page
    # variants, not public pages: they are excluded from routing and listings, and are
    # only reachable via `variants_for`.
    VARIANT_MARKER = "+".freeze

    attr_reader :content_dirs

    class << self
      def find(template, content_dirs = nil)
        instance(content_dirs).find template
      end

      def list(content_dirs = nil)
        instance(content_dirs).list
      end

      def variants_for(base_path, content_dirs = nil)
        instance(content_dirs).variants_for(base_path)
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
      raise NotMarkdownTemplate, template if variant_template?(template)

      preloaded? ? find_from_preloaded(template) : find_now(template)
    end
    alias_method :[], :find

    # Returns the variants for a base page as a { token => frontmatter } hash, e.g.
    # `{ "v1" => { valid_from: ... } }`. Works whether or not the instance is preloaded.
    def variants_for(base_path)
      preloaded? ? variants[base_path] || {} : find_variants_now(base_path)
    end

    def list
      preload unless preloaded?

      frontmatter
    end
    alias_method :to_h, :find

    def preload
      frontmatter # ensure the public page store exists even in a variant-only dir

      content_dirs.reverse.each do |content_dir|
        Dir.glob(content_pattern(content_dir)) do |found|
          next if File.basename(found).starts_with? "_"

          if variant_file?(found)
            add_variant content_dir, found
          else
            add path(content_dir, found), found
          end
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

    def variants
      @variants ||= {}
    end

    def add(template_path, file)
      frontmatter[template_path] = extract_frontmatter(file)
    end

    def add_variant(content_dir, file)
      base_path, token = split_variant_template path(content_dir, file)
      variants[base_path] ||= {}
      variants[base_path][token] = extract_frontmatter(file)
    end

    def find_variants_now(base_path)
      unprefixed = base_path.delete_prefix("/")

      {}.tap do |found_variants|
        content_dirs.each do |content_dir|
          Dir.glob(content_dir.join("#{unprefixed}#{VARIANT_MARKER}*.{md,markdown}")) do |file|
            token = variant_token(file)
            found_variants[token] ||= extract_frontmatter(file)
          end
        end
      end
    end

    def variant_file?(file)
      variant_basename? File.basename(file, ".*")
    end

    def variant_template?(template)
      variant_basename? File.basename(template.to_s)
    end

    def variant_basename?(basename)
      basename.include? VARIANT_MARKER
    end

    def variant_token(file)
      File.basename(file, ".*").split(VARIANT_MARKER, 2).last
    end

    def split_variant_template(template_path)
      name, token = File.basename(template_path).split(VARIANT_MARKER, 2)
      [File.join(File.dirname(template_path), name), token]
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
