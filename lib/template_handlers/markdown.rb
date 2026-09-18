require "table_captions"
require "values"

module TemplateHandlers
  class Markdown
    include ActionView::Helpers::OutputSafetyHelper
    include Values

    attr_reader :template, :source, :options

    DEFAULTS = {}.freeze
    GLOBAL_FRONT_MATTER = Rails.root.join("config/frontmatter.yml").freeze
    COMPONENT_TYPES = %w[quote quote_list inset_text youtube_video steps expander cta_adviser cta_routes cta_mailinglist cta_arrow_link timed_financial_content].freeze

    # Components in this list are rendered per-request in the live view context
    # instead of being baked into the compiled template. Everything else is
    # rendered once, at template-compile time, via ApplicationController.render
    # (which runs outside the request cycle). These components need to read
    # request state at render time - e.g. TimedFinancialContentComponent reads
    # the `?now=` debugging override from params - which is not available when
    # the template is compiled.
    RUNTIME_COMPONENT_TYPES = %w[timed_financial_content].freeze

    class << self
      def call(template, source = nil)
        new(template, source).call
      end

      def global_front_matter
        @global_front_matter ||= if GLOBAL_FRONT_MATTER.exist?
                                   YAML.load_file(GLOBAL_FRONT_MATTER) || {}
                                 else
                                   {}
                                 end
      end
    end

    def initialize(template, source = nil, **options)
      @template = template
      @source = source.to_s

      @options = DEFAULTS.merge(options)
    end

    def call
      # `render` bakes most content into a string literal but leaves markers for
      # runtime components, which `compile_body` turns into per-request render
      # calls (see RUNTIME_COMPONENT_TYPES).
      body = compile_body(render)

      return body if front_matter == TemplateHandlers::Markdown.global_front_matter

      %(@front_matter = #{front_matter.inspect}; #{body})
    end

  private

    def render_markdown
      Kramdown::Document.new(markdown, { toc_levels: 1..2 }).to_html
    end

    def autolink_html(content)
      Rinku.auto_link content
    end

    def add_table_captions(content)
      TableCaptions.new(content).render
    end

    def render
      add_table_captions autolink_html render_markdown
    end

    def markdown
      # use $1 rather than a block argument here because gsub assigns the
      # entire placeholder to the arg (including dollar symbols) but we only
      # want what's inside the capture group
      # NB: we need to parse a second time as a component may contain a $value$
      substitute_values(substitute_components_and_values(parsed.content))
    end

    # rubocop:disable Style/PerlBackrefs
    def substitute_components_and_values(content)
      content.gsub(PLACEHOLDER_REGEX) do
        safe_join([cta_component($1), content_component($1), image($1), value($1)].compact).strip
      end
    end
    # rubocop:enable Style/PerlBackrefs

    def cta_component(placeholder)
      component = Content::CallToActionComponentInjector.new(
        front_matter.dig("calls_to_action", placeholder),
      ).component

      return unless component

      ApplicationController.render(component, layout: false)
    end

    def content_component(placeholder)
      component_type = COMPONENT_TYPES.find { |type| front_matter.dig(type, placeholder) }

      return unless component_type

      # Defer to a per-request render rather than baking the output in now.
      return runtime_component_marker(component_type, placeholder) if RUNTIME_COMPONENT_TYPES.include?(component_type)

      component = Content::ComponentInjector.new(
        component_type,
        front_matter.dig(component_type, placeholder),
      ).component

      return unless component

      ApplicationController.render(component, layout: false)
    end

    # Records the component so it can be rendered at request time and leaves a
    # placeholder in the markdown. An empty block-level <div> is used because
    # Kramdown, Rinku and the table caption pass all leave it verbatim when the
    # token is alone on its own line. The per-compile nonce makes it impossible
    # for authored page content to collide with a marker.
    def runtime_component_marker(component_type, placeholder)
      index = runtime_components.length
      runtime_components << {
        type: component_type,
        params: front_matter.dig(component_type, placeholder),
      }
      # html_safe so the enclosing safe_join in substitute_components_and_values
      # doesn't escape the marker before it reaches Kramdown.
      runtime_marker(index).html_safe
    end

    def runtime_components
      @runtime_components ||= []
    end

    # Single source of truth for the marker string, shared by the builder above
    # and the splitter in compile_body. Keep this and runtime_marker_pattern in
    # step.
    def runtime_marker(index)
      %(<div data-dynamic-component="#{marker_nonce}-#{index}"></div>)
    end

    # Matches a marker in the rendered HTML in either its raw form (token alone
    # on its own line) or the HTML-escaped form Kramdown emits when the token is
    # used inline or inside a table cell. Capturing group is the component index.
    def runtime_marker_pattern
      nonce = Regexp.escape(marker_nonce)
      %r{(?:<|&lt;)div data-dynamic-component="#{nonce}-(\d+)"(?:>|&gt;)(?:<|&lt;)/div(?:>|&gt;)}
    end

    def marker_nonce
      @marker_nonce ||= SecureRandom.hex(8)
    end

    # Splits the rendered HTML on the runtime-component markers and rebuilds it
    # as a `safe_join` of the literal segments and live `render` calls, so the
    # runtime components are rendered per-request in the real view context.
    def compile_body(html)
      return %(#{html.inspect}.html_safe) if runtime_components.empty?

      segments = html.split(runtime_marker_pattern, -1)
      code = segments.each_with_index.map do |segment, index|
        index.odd? ? runtime_component_code(segment.to_i) : %(#{segment.inspect}.html_safe)
      end

      %(safe_join([#{code.join(', ')}]))
    end

    def runtime_component_code(index)
      component = runtime_components.fetch(index)
      %(render(Content::ComponentInjector.new(#{component[:type].inspect}, #{component[:params].inspect}).component))
    end

    def image(placeholder)
      image_args = front_matter.dig("images", placeholder)

      return unless image_args

      component = Content::ImageComponent.new(path: image_args["path"])

      ApplicationController.render(component, layout: false)
    end

    def front_matter
      @front_matter ||= self.class.global_front_matter.deep_merge(parsed.front_matter)
    end

    def parsed
      @parsed ||= parser.call(source)
    end

    def parser
      FrontMatterParser::Parser.new(:md)
    end
  end
end
