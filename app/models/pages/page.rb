module Pages
  class Page
    class PageNotFoundError < RuntimeError; end

    TEMPLATES_FOLDER = "content".freeze
    MAX_TRAVERSAL_DEPTH = 100

    attr_reader :path, :frontmatter, :variant

    delegate :title, :heading, :image, to: :frontmatter

    class << self
      def find(path)
        new path, Pages::Frontmatter.find(path)
      rescue Pages::Frontmatter::NotMarkdownTemplate => e
        raise PageNotFoundError, e.message
      end

      # Resolves which version of a page to render. An explicit (development-only)
      # +version+ pins that variant, bypassing dates; otherwise the variant whose
      # valid_from..valid_to window contains +now+ is used, and failing that the base
      # page. Overlapping windows resolve to the latest valid_from.
      #
      # A resolved variant keeps the base +path+ (so breadcrumbs and the canonical URL
      # are unchanged) and the variant's own frontmatter, and carries a +variant+ token.
      # The token is handed to Rails' native template variants at render time, which is
      # how the +vN.md body is picked up.
      def resolve(path, version: nil, now: Time.current)
        variants = Pages::Frontmatter.variants_for(path)
        token = pinned_token(variants, version) || active_token(path, variants, now)

        return find(path) unless token

        new path, variants.fetch(token), variant: token
      end

      def featured
        pages = Pages::Frontmatter.select(:featured_story_card)
        return nil? if pages.empty?
        raise MultipleFeatured, pages.keys if pages.many?

        new(*pages.first)
      end

    private

      def pinned_token(variants, version)
        version.to_s if version.present? && variants.key?(version.to_s)
      end

      def active_token(path, variants, now)
        active = variants.select { |_token, frontmatter| within_window?(frontmatter, now) }
        return if active.empty?

        warn_overlapping_variants(path, active) if active.size > 1

        # Every active variant has a valid_from (within_window? requires it), so the key
        # is never nil.
        active.max_by { |_token, frontmatter| parse_time(frontmatter[:valid_from]) }.first
      end

      # A variant is only auto-selected inside its window. valid_from is required: a
      # variant without it is ignored, so the base page keeps serving and a variant that
      # forgets its dates never silently hijacks the page. valid_to is optional -- an
      # absent valid_to is an open end (a nil range endpoint), meaning "from valid_from
      # onwards". Window containment mirrors Content::TimedFinancialContentComponent.
      def within_window?(frontmatter, now)
        valid_from = parse_time(frontmatter[:valid_from])
        return false if valid_from.nil?

        now.in?(valid_from..parse_time(frontmatter[:valid_to]))
      end

      def parse_time(value)
        Time.zone.parse(value.to_s) if value.present?
      end

      def warn_overlapping_variants(path, active)
        return unless Rails.env.development?

        Rails.logger.warn("Overlapping page variants active for #{path}: #{active.keys.join(', ')}")
      end
    end

    def initialize(path, frontmatter, variant: nil)
      @path = path
      @frontmatter = OpenStruct.new(frontmatter)
      @variant = variant
    end

    def template
      TEMPLATES_FOLDER + path
    end

    def data
      @data ||= Pages::Data.new
    end

    def parent
      pathname = Pathname.new(path)

      (0...MAX_TRAVERSAL_DEPTH).each do
        pathname = pathname.parent
        return nil if pathname.root?

        return self.class.find(pathname.to_s)
      rescue PageNotFoundError
        next
      end
    end

    def ancestors
      ancestors = []
      page = self

      (0...MAX_TRAVERSAL_DEPTH).each do
        page = page.parent
        return ancestors if page.nil?

        ancestors << page
      end
    end

    class MultipleFeatured < RuntimeError
      def initialize(page_paths)
        super "There are multiple featured pages: #{page_paths.join(', ')}"
      end
    end
  end
end
