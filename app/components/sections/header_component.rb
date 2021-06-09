module Sections
  class HeaderComponent < ViewComponent::Base
    def nav_link(link_text, link_path)
      class_name = "active" if first_uri_segment_matches_link?(link_path)

      tag.li class: class_name do
        link_to_unless_current(link_text, link_path)
      end
    end

  private

    def first_uri_segment_matches_link?(link_path)
      current_uri = request.path
      if (matches = /^\/[^\/]*/.match(current_uri))
        matches[0] == link_path
      end
    end
  end
end
