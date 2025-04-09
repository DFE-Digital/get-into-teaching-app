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

    def nav_link(resource, mode, underline_on_hover: true, role: "menuitem")
      title = resource.title
      path = resource.path
      li_id = "#{path.parameterize}-#{mode}"
      child_menu_id = category_list_id(resource, mode)

      li_css = ("active" if uri_is_root?(path) || first_uri_segment_matches_link?(path)).to_s
      show_dropdown = resource.children?
      link_css = "menu-link link link--black link--no-underline #{underline_on_hover ? 'link--underline-on-hover' : ''}"
      aria_attributes = show_dropdown ? { expanded: false, controls: child_menu_id } : {}
      tag.li id: li_id, class: li_css, data: { "child-menu-id": child_menu_id, "direct-link": !show_dropdown } do
        safe_join([
          link_to(path, class: link_css, role: role, aria: aria_attributes, data: { action: "keydown.enter->navigation#handleNavMenuClick" }) do
            safe_join([
              tag.span(title, class: "menu-title"),
              contracted_icon(visible: show_dropdown),
            ])
          end,
          if mode == :mobile && resource.children?
            [
              row_break,
              category_list(resource, mode, css_class: "category-links-list hidden-menu hidden-desktopXXX"),
            ]
          end,
        ])
      end
    end

    def category_list(resource, mode, css_class:, role: "menu")
      tag.div(class: "desktop-level2-wrapper") do
        tag.ol(class: css_class, id: category_list_id(resource, mode), role: role) do
          safe_join(
            [
              resource.children_without_subcategory.map do |child_resource|
                nav_link(child_resource, mode)
              end,
              resource.subcategories.map do |category|
                category_link(category, resource, mode)
              end,
              view_all_link(resource, mode),
            ],
          )
        end
      end
    end

    def category_list_id(resource, mode)
      "#{resource.path.parameterize}-categories-#{mode}"
    end

    def category_link(subcategory, resource, mode, role: "menuitem")
      title = subcategory
      li_id = "#{resource.path.parameterize}-#{title.parameterize}-#{mode}"
      child_menu_id = page_list_id(resource, subcategory, mode)

      li_css = ("active" if subcategory == front_matter["subcategory"]).to_s
      link_css = "menu-link link link--black link--no-underline link--underline-on-hover btn-as-link"
      aria_attributes = { expanded: false, controls: child_menu_id }
      tag.li id: li_id, class: li_css, data: { "child-menu-id": child_menu_id, "direct-link": false } do
        safe_join(
          [
            tag.button(type: "button", class: link_css, role: role, aria: aria_attributes, data: { action: "keydown.enter->navigation#handleNavMenuClick" }) do
              safe_join(
                [
                  tag.span(title, class: "menu-title"),
                  contracted_icon(visible: true),
                ],
              )
            end,
            row_break,
            if mode == :mobile
              page_list(resource, subcategory, mode, css_class: "page-links-list hidden-menu hidden-desktopXXX")
            end,
          ],
        )
      end
    end

    def page_list_id(resource, subcategory, mode)
      "#{resource.path.parameterize}-#{subcategory.parameterize}-pages-#{mode}"
    end

    def page_list(resource, subcategory, mode, css_class:, role: "menu")
      tag.div(class: "desktop-level3-wrapper") do
        tag.ol(class: css_class, role: role, id: page_list_id(resource, subcategory, mode)) do
          safe_join(
            [
              resource.children_in_subcategory(subcategory).map do |child_resource|
                nav_link(child_resource, mode)
              end,
            ],
          )
        end
      end
    end

    def view_all_link(resource, mode, role: "menuitem")
      title = "View all in #{resource.title}"
      path = resource.path
      li_id = "menu-view-all-#{path.parameterize}-#{mode}"
      li_css = "view-all #{'active' if uri_is_root?(path)}"
      link_css = "menu-link link link--black"

      tag.li class: li_css, id: li_id, data: { "direct-link": true } do
        safe_join([
          link_to(path, class: link_css, role: role, data: { action: "keydown.enter->navigation#handleNavMenuClick" }) do
            tag.span(title, class: "menu-title")
          end,
        ])
      end
    end

    def row_break
      tag.div(class: "break", "aria-hidden": true)
    end

    def contracted_icon(visible: true)
      if visible
        tag.span(class: "nav-icon nav-icon__contracted", aria: { hidden: true })
      end
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
