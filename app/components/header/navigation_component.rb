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
      tag.li class: class_name(resource.path), data: { "id": "menu-#{resource.path.parameterize}" } do
        safe_join( [
                     link_to_unless_current(resource.title, resource.path, class: "link--black link--no-underline") { tag.div(resource.title) },
                     if resource.children?
                       tag.span(class: "nav-icon nav-icon__arrow-#{current_page?(resource.path) ? 'up' : 'down'}", "aria-hidden": true)
                     end
                   ])
      end
    end

    def category_link(subcategory, resource)
      tag.li class: category_class_name(subcategory), data: { "id": "menu-#{subcategory.parameterize}" } do
        safe_join( [
                     link_to_unless(subcategory == front_matter["subcategory"], subcategory, "#{resource.path}##{subcategory}", class: "link--black link--no-underline") { tag.div(subcategory) },
                     tag.span(class: "nav-icon nav-icon__arrow-right", "aria-hidden": true),
                   ])
      end
    end

    def view_all_in_resource_link(resource)
      "View all in #{resource.title}".then do |title|
        tag.li class: view_all_in_class_name(resource.path), data: { direct: true } do
          link_to_unless_current(title, resource.path, class: "link--black") { tag.div(title) }
        end
      end
    end

    def class_name(link_path)
      "active" if uri_is_root?(link_path) || first_uri_segment_matches_link?(link_path)
    end

    def category_class_name(subcategory)
      "active" if subcategory == front_matter["subcategory"]
    end

    def view_all_in_class_name(link_path)
      "active" if uri_is_root?(link_path)
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
