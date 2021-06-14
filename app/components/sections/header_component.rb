module Sections
  class HeaderComponent < ViewComponent::Base
    renders_many :primary_items, "PrimaryItem"

    class PrimaryItem < ViewComponent::Base
      attr_accessor :node

      def initialize(...)
        @node = Node.new(...)

        super
      end

      def call
        class_name = "active" if first_uri_segment_matches_link?(node.path)

        if node.front_matter.navigation_only?
          tag.li(class: [class_name, "down"]) do
            safe_join([nav_span(node, class: "multi", data: { action: "click->navigation#toggleWays" }), secondary_items])
          end
        else
          tag.li(class: class_name) do
            nav_link(node)
          end
        end
      end

    private

      def secondary_items
        return nil if node.children.none?

        tag.ol(class: "secondary hidden") do
          safe_join(
            node
              .children
              .map { |child| Node.new(child) }
              .map { |child_node| tag.li(nav_link(child_node)) },
          )
        end
      end

      def nav_link(node)
        link_to_unless_current(node.front_matter.navigation_title, node.path) do
          nav_span(node)
        end
      end

      def nav_span(node, **kwargs)
        tag.span(node.front_matter.navigation_title, tabindex: 0, **kwargs)
      end

      def first_uri_segment_matches_link?(link_path)
        current_uri = request.path
        if (matches = /^\/[^\/]*/.match(current_uri))
          matches[0] == link_path
        end
      end
    end

    # Represents a single navigation item, either primary or secondary
    class Node
      attr_reader :path, :front_matter, :children

      def initialize(path:, front_matter:, children: [])
        @path         = path
        @front_matter = FrontMatterNavigation.new(front_matter)
        @children     = children
      end
    end

    # Retrieve only the data we're interested in from the front matter
    class FrontMatterNavigation
      attr_reader :title, :path

      def initialize(**front_matter)
        @navigation_title = front_matter[:navigation_title]
        @navigation_only  = front_matter[:navigation_only]
        @title            = front_matter[:title]
        @path             = front_matter[:path]
      end

      def navigation_title
        @navigation_title || title
      end

      def navigation_only?
        @navigation_only
      end
    end
  end
end
