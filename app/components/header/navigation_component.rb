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

    def sync_mode(mode)
      mode == :mobile ? :desktop : :mobile
    end

    def nav_link(resource, mode, level: 1)
      title = resource.title
      path = resource.path
      li_id = "#{path.parameterize}-#{mode}"
      li_sync_id = "#{path.parameterize}-#{sync_mode(mode)}"
      child_menu_id = category_list_id(resource, mode)
      child_menu_sync_id = category_list_id(resource, sync_mode(mode))
      child_menu_ids = [child_menu_id, child_menu_sync_id].join(" ")
      li_css = ("active" if uri_is_root?(path) || first_uri_segment_matches_link?(path)).to_s
      show_dropdown = resource.children?
      link_css = show_dropdown || level > 1 ? "grow link--black link--no-underline" : "grow link--black"
      aria_attributes = show_dropdown ? { expanded: false, controls: child_menu_ids } : {}
      tag.li id: li_id, class: li_css, data: { "sync-id": li_sync_id, "child-menu-id": child_menu_id, "child-menu-sync-id": child_menu_sync_id, "direct-link": !show_dropdown, "toggle-secondary-navigation": show_dropdown } do
        safe_join([
          link_to(title, path, class: link_css, aria: aria_attributes),
          if show_dropdown
            contracted_icon
          end,
          if mode == :mobile && resource.children?
            [
              row_break,
              category_list(resource: resource, css_class: "category-links-list hidden-menu hidden-desktop", mode: mode),
            ]
          end,
        ])
      end
    end

    def category_list(resource:, css_class:, mode:)
      tag.ol(class: css_class, id: category_list_id(resource, mode)) do
        safe_join(
          [
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
      title = subcategory || "Main details"
      li_id = "#{resource.path.parameterize}-#{title.parameterize}-#{mode}"
      li_sync_id = "#{resource.path.parameterize}-#{title.parameterize}-#{sync_mode(mode)}"
      child_menu_id = page_list_id(resource, subcategory, mode)
      child_menu_sync_id = page_list_id(resource, subcategory, sync_mode(mode))
      child_menu_ids = [child_menu_id, child_menu_sync_id].join(" ")
      li_css = ("active" if subcategory == front_matter["subcategory"]).to_s
      link_css = "link link--black link--no-underline btn-as-link"
      aria_attributes = { expanded: false, controls: child_menu_ids }
      tag.li id: li_id, class: li_css, data: { "sync-id": li_sync_id, "child-menu-id": child_menu_id, "child-menu-sync-id": child_menu_sync_id, "direct-link": false } do
        safe_join([
          tag.button(title, type: "button", class: link_css, aria: aria_attributes),
          contracted_icon,
          row_break,
          if mode == :mobile
            page_list(resource: resource, subcategory: subcategory, css_class: "page-links-list hidden-menu hidden-desktop", mode: mode)
          end,
        ])
      end
    end

    def page_list_id(resource, subcategory, mode)
      "#{resource.path.parameterize}-#{(subcategory || 'details').parameterize}-pages-#{mode}"
    end

    def page_list(resource:, subcategory:, css_class:, mode:)
      tag.ol(class: css_class, id: page_list_id(resource, subcategory, mode)) do
        safe_join(
          [
            resource.children_in_subcategory(subcategory).map do |child_resource|
              nav_link(child_resource, mode, level: 3)
            end,
          ],
        )
      end
    end

    def view_all_link(resource, mode)
      title = "View all in #{resource.title}"
      path = resource.path
      id = "menu-view-all-#{path.parameterize}-#{mode.parameterize}"
      li_css = "view-all #{'active' if uri_is_root?(path)}"
      link_css = "link--black"

      tag.li class: li_css, data: { id: id, "direct-link": true } do
        link_to(title, path, class: link_css)
      end
    end

    def row_break
      tag.div(class: "break", "aria-hidden": true)
    end

    def contracted_icon
      tag.span(class: "nav-icon nav-icon__contracted", aria: { hidden: true })
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
