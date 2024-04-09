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
      toggle_child_menu_inline_id = "#{path.parameterize}-menu-categories"
      toggle_child_menu_dropdown_id = "#{path.parameterize}-dropdown-categories"
      toggle_child_menu_ids = [toggle_child_menu_inline_id, toggle_child_menu_dropdown_id].join(" ")

      li_css = ("active" if uri_is_root?(path) || first_uri_segment_matches_link?(path)).to_s
      link_css = "grow link--black link--no-underline"
      show_dropdown = resource.subcategories?
      aria_attributes = show_dropdown ? { expanded: false, controls: toggle_child_menu_ids } : {}
      tag.li class: li_css, data: { "toggle-ids": toggle_child_menu_ids, "direct-link": !show_dropdown } do
        safe_join([
          link_to(title, path, class: link_css, aria: aria_attributes),
          if show_dropdown
            expandable_icon
          end,
          if resource.subcategories?
            [
              row_break,

              tag.ol(class: "category-links-list hidden-menu", id: toggle_child_menu_inline_id, data: { selectors: "ol.page-links-list, ol.page-navigation" }) do
                safe_join(
                  [
                    resource.subcategories.map { |category| category_link(category, resource) },
                    view_all_link(resource),
                  ],
                )
              end,
            ]
          end,
        ])
      end
    end

    def category_link(subcategory, resource)
      title = subcategory
      path = "#{resource.path}##{subcategory.parameterize}"
      toggle_child_menu_inline_id = "#{resource.path.parameterize}-#{subcategory.parameterize}-menu-pages"
      toggle_child_menu_dropdown_id = "#{resource.path.parameterize}-#{subcategory.parameterize}-dropdown-pages"
      toggle_child_menu_ids = [toggle_child_menu_inline_id, toggle_child_menu_dropdown_id].join(" ")

      li_css = ("active" if subcategory == front_matter["subcategory"]).to_s
      link_css = "link--black link--no-underline"
      aria_attributes = { expanded: false, controls: toggle_child_menu_ids }
      tag.li class: li_css, data: { "toggle-ids": toggle_child_menu_ids } do
        safe_join([
          link_to(title, path, class: link_css, aria: aria_attributes),
          expandable_icon,
          row_break,

          tag.ol(class: "page-links-list hidden-menu", id: toggle_child_menu_inline_id) do
            safe_join(
              [
                resource.children_in_subcategory(subcategory).map { |child_resource| nav_link(child_resource) },
              ],
            )
          end,
        ])
      end
    end

    def view_all_link(resource)
      title = "View all in #{resource.title}"
      path = resource.path
      id = "menu-view-all-#{resource.path.parameterize}"
      li_css = "view-all #{'active' if uri_is_root?(path)}"
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
