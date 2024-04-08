module Header
  class NavigationComponent < ViewComponent::Base
    attr_reader :resources, :extra_resources, :front_matter

    def initialize(resources: nil, extra_resources: {}, front_matter: {})
      super

      @resources       = resources
      @extra_resources = build_additional_resource_nodes(extra_resources)
      @front_matter    = front_matter
    end

    def before_render
      @resources ||= helpers.navigation_resources
    end

    def all_resources
      resources + extra_resources
    end

  private

    def nav_link(resource)
      title = resource.title
      path = resource.path
      id = "menu-#{path.parameterize}"
      li_css = "active" if uri_is_root?(path) || first_uri_segment_matches_link?(path)
      link_css = "grow link--black link--no-underline"
      show_dropdown = resource.subcategories?
      aria_attributes = show_dropdown ? { expanded: false, controls: id } : {}

      tag.li class: li_css, data: { "id": id, "direct-link": !show_dropdown } do
        safe_join([
          link_to(title, path, class: link_css, aria: aria_attributes),
          if show_dropdown
            expandable_icon
          end,
          if resource.subcategories?
            [
              row_break,
              tag.ol(class: "category-links-list") do
                safe_join(
                  [
                    resource.subcategories.map { |category| category_link(category, resource) },
                    view_all_link(resource),
                  ]
                )
              end
            ]
          end
        ])
      end
    end

    def category_link(subcategory, resource)
      title = subcategory
      path = "#{resource.path}##{subcategory.parameterize}"
      id = "menu-#{subcategory.parameterize}"
      li_css = "active" if subcategory == front_matter["subcategory"]
      link_css = "link--black link--no-underline"
      aria_attributes = { expanded: false, controls: id }
      tag.li class: li_css, data: { "id": id } do
        safe_join([
          link_to(title, path, class: link_css, aria: aria_attributes),
          expandable_icon,
          row_break,
          tag.ol(class: 'page-links-list') do
            safe_join(
              [
                resource.children_in_subcategory(subcategory).map { |child_resource| nav_link(child_resource) }
              ]
            )
          end
        ])
      end
    end

    def view_all_link(resource)
      title = "View all in #{resource.title}"
      path = resource.path
      id = "menu-view-all-#{resource.path.parameterize}"
      li_css = "view-all #{active if uri_is_root?(path)}"
      link_css = "link--black"

      tag.li class: li_css, data: { id: id, "direct-link": true } do
        link_to(title, path, class: link_css)
      end
    end

  def row_break
    tag.div(class: "break", "aria-hidden": true)
  end

    # def down_arrow_icon
    #   tag.span(class: "nav-icon nav-icon__arrow-down", "aria-hidden": true)
    # end

    # def right_arrow_icon
    #   tag.span(class: "nav-icon nav-icon__arrow-right", "aria-hidden": true)
    # end

    def expandable_icon
      tag.span(class: "nav-icon nav-icon__arrow-down", "aria-hidden": true)
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
