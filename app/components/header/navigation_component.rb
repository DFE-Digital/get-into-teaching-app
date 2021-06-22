module Header
  class NavigationComponent < ViewComponent::Base
    attr_reader :resources, :extra_resources

    def initialize(resources: nil, extra_resources: {})
      @resources       = resources
      @extra_resources = build_additional_resource_nodes(extra_resources)
    end

    def before_render
      @resources ||= helpers.navigation_resources
    end

    def all_resources
      resources + extra_resources
    end

  private

    def nav_link(link_text, link_path)
      tag.li class: class_name(link_path) do
        link_to_unless_current link_text, link_path
      end
    end

    def menu(link_text, link_path, children)
      heading_args = { class: "menu__heading", data: { action: "click->navigation#toggleMenu" } }

      link_content = safe_join([link_text, tag.div(class: "menu-chevron")])

      tag.li(class: ["menu", class_name(link_path)]) do
        safe_join(
          [
            link_to_unless_current(link_content, link_path, **heading_args) do
              tag.span(link_content, **heading_args)
            end,
            tag.ol(class: %w[secondary hidden-desktop]) do
              safe_join(
                children.map do |child|
                  tag.li(link_to(child.title, child.path))
                end,
              )
            end,
          ],
        )
      end
    end

    def class_name(link_path)
      "active" if uri_is_root?(link_path) || first_uri_segment_matches_link?(link_path)
    end

    def uri_is_root?(link_path)
      request.path == link_path
    end

    def first_uri_segment_matches_link?(link_path)
      current_uri = request.path
      if (matches = /^\/[^\/]*/.match(current_uri))
        matches[0] == link_path
      end
    end

    def build_additional_resource_nodes(extra_resources)
      extra_resources.map { |path, title| OpenStruct.new(path: path, title: title) }
    end
  end
end
