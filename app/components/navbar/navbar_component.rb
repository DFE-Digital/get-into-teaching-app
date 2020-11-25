module Navbar
  class NavbarComponent < ViewComponent::Base
    def initialize(sitemap)
      @sitemap = sitemap
    end

  private

    def resources
      helpers.navigation_resources(@sitemap)
    end

    def nav_link(link_text, link_path)
      class_name = "active" if first_uri_segment_matches_link?(link_path)
      content_tag(:li, class: class_name) do
        link_to link_text, link_path
      end
    end

    def first_uri_segment_matches_link?(link_path)
      current_uri = request.env["PATH_INFO"]
      /^\/[^\/]*/.match(current_uri)[0] == link_path
    end
  end
end
