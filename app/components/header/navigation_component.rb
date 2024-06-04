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

    def corresponding_mode(mode)
      mode == :mobile ? :desktop : :mobile
    end

    def nav_link(resource, mode)
      title = resource.title
      path = resource.path
      li_id = "#{path.parameterize}-#{mode}"
      corresponding_li_id = "#{path.parameterize}-#{corresponding_mode(mode)}"
      child_menu_id = category_list_id(resource, mode)
      corresponding_child_menu_id = category_list_id(resource, corresponding_mode(mode))
      child_menu_ids = [child_menu_id, corresponding_child_menu_id].join(" ")
      li_css = ("active" if uri_is_root?(path) || first_uri_segment_matches_link?(path)).to_s
      show_dropdown = resource.children?
      link_css = "menu-link link link--black link--no-underline"
      aria_attributes = show_dropdown ? { expanded: false, controls: child_menu_ids } : {}
      tag.li id: li_id, class: li_css, data: { "corresponding-id": corresponding_li_id, "child-menu-id": child_menu_id, "corresponding-child-menu-id": corresponding_child_menu_id, "direct-link": !show_dropdown, "toggle-secondary-navigation": show_dropdown } do
        safe_join([
          link_to(path, class: link_css, aria: aria_attributes, data: { action: "keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" }) do
            safe_join([
              tag.span(title, class: "menu-title"),
              contracted_icon(visible: show_dropdown),
            ])
          end,
          if mode == :mobile && resource.children?
            [
              row_break,
              category_list(resource, mode, css_class: "category-links-list hidden-menu hidden-desktop"),
            ]
          end,
        ])
      end
    end

    def category_list(resource, mode, css_class:)
      tag.ol(class: css_class, id: category_list_id(resource, mode)) do
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

    def category_list_id(resource, mode)
      "#{resource.path.parameterize}-categories-#{mode}"
    end

    def category_link(subcategory, resource, mode)
      title = subcategory
      li_id = "#{resource.path.parameterize}-#{title.parameterize}-#{mode}"
      corresponding_li_id = "#{resource.path.parameterize}-#{title.parameterize}-#{corresponding_mode(mode)}"
      child_menu_id = page_list_id(resource, subcategory, mode)
      corresponding_child_menu_id = page_list_id(resource, subcategory, corresponding_mode(mode))
      child_menu_ids = [child_menu_id, corresponding_child_menu_id].join(" ")
      li_css = ("active" if subcategory == front_matter["subcategory"]).to_s
      link_css = "menu-link link link--black link--no-underline btn-as-link"
      aria_attributes = { expanded: false, controls: child_menu_ids }
      tag.li id: li_id, class: li_css, data: { "corresponding-id": corresponding_li_id, "child-menu-id": child_menu_id, "corresponding-child-menu-id": corresponding_child_menu_id, "direct-link": false } do
        safe_join(
          [
            tag.button(type: "button", class: link_css, aria: aria_attributes, data: { action: "keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" }) do
              safe_join(
                [
                  tag.span(title, class: "menu-title"),
                  contracted_icon(visible: true),
                ],
              )
            end,
            row_break,
            if mode == :mobile
              page_list(resource, subcategory, mode, css_class: "page-links-list hidden-menu hidden-desktop")
            end,
          ],
        )
      end
    end

    def page_list_id(resource, subcategory, mode)
      "#{resource.path.parameterize}-#{subcategory.parameterize}-pages-#{mode}"
    end

    def page_list(resource, subcategory, mode, css_class:)
      tag.ol(class: css_class, id: page_list_id(resource, subcategory, mode)) do
        safe_join(
          [
            resource.children_in_subcategory(subcategory).map do |child_resource|
              nav_link(child_resource, mode)
            end,
          ],
        )
      end
    end

    def view_all_link(resource, mode)
      title = "View all in #{resource.title}"
      path = resource.path
      li_id = "menu-view-all-#{path.parameterize}-#{mode}"
      corresponding_li_id = "menu-view-all-#{path.parameterize}-#{corresponding_mode(mode)}"
      li_css = "view-all #{'active' if uri_is_root?(path)}"
      link_css = "menu-link link link--black"

      tag.li class: li_css, id: li_id, data: { "corresponding-id": corresponding_li_id, "direct-link": true } do
        safe_join([
          link_to(path, class: link_css, data: { action: "keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" }) do
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
